import { Output, randomPassword, Services } from "~templates-utils";
import { Input } from "./meta";

export function generate(input: Input): Output {
  const services: Services = [];
  const dbPassword = randomPassword();
  const dbServiceName = `${input.projectName}-db`;
  const gravServiceName = `${input.projectName}-grav`;
  const slimsServiceName = `${input.projectName}-slims`;

  // ---------- Database (MySQL 5.7 — dibutuhkan SLiMS 9) ----------
  services.push({
    type: "app",
    data: {
      serviceName: dbServiceName,
      env: [
        `MYSQL_ROOT_PASSWORD=${dbPassword}`,
        `MYSQL_DATABASE=slims`,
        `MYSQL_USER=slims`,
        `MYSQL_PASSWORD=${dbPassword}`,
      ].join("\n"),
      source: {
        type: "image",
        image: "mysql:5.7",
      },
      mounts: [
        {
          type: "volume",
          name: "data",
          mountPath: "/var/lib/mysql",
        },
      ],
    },
  });

  // ---------- Front-end website (Grav + konten produk) ----------
  services.push({
    type: "app",
    data: {
      serviceName: gravServiceName,
      env: [
        `GRAV_SETUP=true`,
        `GRAV_SCHEDULER=true`,
        `FIX_PERMISSIONS=true`,
        `GRAV_ADMIN_PASSWORD=${input.gravAdminPassword}`,
        `DB_HOST=${dbServiceName}`,
        `DB_PORT=3306`,
        `DB_USER=slims`,
        `DB_PASS=${dbPassword}`,
        `DB_NAME=slims`,
        `OPAC_URL=https://${input.opacSubdomain}.${input.rootDomain}`,
      ].join("\n"),
      source: {
        type: "git",
        repoUrl: input.repoUrl,
        ref: input.repoRef,
        dockerfilePath: "grav/Dockerfile",
        buildContextPath: "/",
      },
      domains: [
        {
          host: input.rootDomain,
          port: 80,
        },
      ],
      mounts: [
        {
          type: "volume",
          name: "data",
          mountPath: "/var/www/html",
        },
      ],
    },
  });

  // ---------- OPAC (SLiMS 9) ----------
  services.push({
    type: "app",
    data: {
      serviceName: slimsServiceName,
      env: [
        `ENV=production`,
        `DB_HOST=${dbServiceName}`,
        `DB_PORT=3306`,
        `DB_USER=slims`,
        `DB_PASS=${dbPassword}`,
        `DB_NAME=slims`,
      ].join("\n"),
      source: {
        type: "git",
        repoUrl: input.repoUrl,
        ref: input.repoRef,
        dockerfilePath: "slims/Dockerfile",
        buildContextPath: "slims",
      },
      domains: [
        {
          host: `${input.opacSubdomain}.${input.rootDomain}`,
          port: 80,
        },
      ],
      mounts: [
        {
          type: "volume",
          name: "data",
          mountPath: "/var/www/html",
        },
      ],
    },
  });

  return { services };
}
