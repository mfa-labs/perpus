<?php
namespace Grav\Plugin;

use Grav\Common\Plugin;
use RocketTheme\Toolbox\Event\Event;

/**
 * Plugin Statistik — menampilkan statistik perpustakaan (F05 PRD).
 *
 * Membaca data dari database SLiMS (biblio, member, loan, visitor)
 * lalu menyediakannya ke tema lewat $grav['theme']->stats / grav.theme.stats.
 *
 * Konfigurasi dibaca dari environment (DB_HOST, DB_PORT, DB_USER, DB_PASS, DB_NAME)
 * agar tidak ada kredensial di file statis.
 */
class StatistikPlugin extends Plugin
{
    public static function getSubscribedEvents(): array
    {
        return [
            'onTwigPageVariables' => ['onTwigPageVariables', 0],
            'onTwigSiteVariables' => ['onTwigSiteVariables', 0],
        ];
    }

    public function onTwigPageVariables(): void
    {
        $this->provideStatsToTwig();
    }

    public function onTwigSiteVariables(): void
    {
        $this->provideStatsToTwig();
    }

    private function provideStatsToTwig(): void
    {
        $stats = $this->fetchStats();

        $this->grav['twig']->twig_vars['statistik'] = $stats;

        // URL OPAC untuk link "Katalog" di halaman statis (diisi dari env)
        $opacUrl = getenv('OPAC_URL') ?: ($this->grav['config']->get('extra.opac_url') ?: 'OPAC_URL_PLACEHOLDER');
        $this->grav['twig']->twig_vars['opac_url'] = $opacUrl;

        if (method_exists($this->grav['theme'], 'setStats')) {
            $this->grav['theme']->setStats($stats);
        }
    }

    private function fetchStats(): array
    {
        $empty = [
            'koleksi'    => 0,
            'anggota'    => 0,
            'peminjaman' => 0,
            'kunjungan'  => 0,
        ];

        $host = getenv('DB_HOST') ?: null;
        $user = getenv('DB_USER') ?: null;
        $pass = getenv('DB_PASS') ?: null;
        $name = getenv('DB_NAME') ?: 'slims';
        $port = getenv('DB_PORT') ?: '3306';

        // Jika DB SLiMS tidak diset (mis. dev tanpa env), tampilkan kosong.
        if (!$host || !$user) {
            return $empty;
        }

        try {
            $dsn = sprintf('mysql:host=%s;port=%d;dbname=%s;charset=utf8mb4', $host, (int)$port, $name);
            $pdo = new \PDO($dsn, $user, $pass, [
                \PDO::ATTR_TIMEOUT => 3,
                \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
            ]);

            $queries = [
                'koleksi'    => 'SELECT COUNT(*) FROM biblio WHERE opac_hide = 0',
                'anggota'    => 'SELECT COUNT(*) FROM member',
                'peminjaman' => 'SELECT COUNT(*) FROM loan',
                'kunjungan'  => 'SELECT COUNT(*) FROM visitor',
            ];

            $stats = $empty;
            foreach ($queries as $key => $sql) {
                try {
                    $stats[$key] = (int)$pdo->query($sql)->fetchColumn();
                } catch (\PDOException $e) {
                    // Tabel mungkin belum ada di DB non-SLiMS; biarkan 0.
                    $stats[$key] = 0;
                }
            }

            return $stats;
        } catch (\PDOException $e) {
            $this->grav['log']->warning('Statistik: gagal terhubung ke DB SLiMS — ' . $e->getMessage());
            return $empty;
        }
    }
}
