<?php
namespace Grav\Theme;

use Grav\Common\Theme;

class Perpus extends Theme
{
    /** @var array|null Data statistik perpustakaan (dari plugin statistik). */
    protected $stats = null;

    public function setStats(array $stats): void
    {
        $this->stats = $stats;
    }

    public function getStats(): ?array
    {
        return $this->stats;
    }
}
