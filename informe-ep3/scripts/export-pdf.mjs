import { spawnSync } from "node:child_process";
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { marked } from "marked";

const __dirname = dirname(fileURLToPath(import.meta.url));
const informeDir = resolve(__dirname, "..");

const files = [
  "01_arquitectura_microservicios.md",
  "02_persistencia_datos.md",
  "03_informe_pruebas_unitarias.md",
];

const browserCandidates = [
  "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
  "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
  "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe",
  "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe",
];

const browser = browserCandidates.find((path) => existsSync(path));

if (!browser) {
  console.error("No se encontró Chrome ni Edge para generar PDF.");
  process.exit(1);
}

const css = `
  @page { margin: 18mm 16mm; }
  body {
    font-family: "Segoe UI", Arial, sans-serif;
    color: #1f2937;
    line-height: 1.55;
    font-size: 11pt;
    max-width: 100%;
  }
  h1 { color: #1e3a8a; font-size: 22pt; border-bottom: 2px solid #dbeafe; padding-bottom: 8px; }
  h2 { color: #1d4ed8; font-size: 15pt; margin-top: 1.4em; }
  h3 { color: #2563eb; font-size: 12.5pt; }
  table { border-collapse: collapse; width: 100%; margin: 12px 0; font-size: 10pt; }
  th, td { border: 1px solid #d1d5db; padding: 6px 8px; text-align: left; vertical-align: top; }
  th { background: #eff6ff; }
  code { background: #f3f4f6; padding: 1px 4px; border-radius: 4px; font-size: 9.5pt; }
  pre { background: #111827; color: #f9fafb; padding: 12px; border-radius: 8px; overflow-x: auto; font-size: 9pt; }
  pre code { background: transparent; color: inherit; }
  img { max-width: 100%; height: auto; margin: 12px 0; }
  blockquote { border-left: 4px solid #93c5fd; margin: 12px 0; padding: 4px 12px; color: #4b5563; }
  hr { border: none; border-top: 1px solid #e5e7eb; margin: 20px 0; }
`;

function wrapHtml(title, body) {
  return `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <title>${title}</title>
  <style>${css}</style>
</head>
<body>${body}</body>
</html>`;
}

function toFileUrl(path) {
  return `file:///${path.replace(/\\/g, "/").replace(/ /g, "%20")}`;
}

async function main() {
for (const file of files) {
  const mdPath = join(informeDir, file);
  const baseName = file.replace(/\.md$/, "");
  const htmlPath = join(informeDir, `${baseName}.html`);
  const pdfPath = join(informeDir, `${baseName}.pdf`);

  const markdown = readFileSync(mdPath, "utf8");
  const htmlBody = await marked.parse(markdown);
  writeFileSync(htmlPath, wrapHtml(baseName, htmlBody), "utf8");

  const result = spawnSync(
    browser,
    [
      "--headless=new",
      "--disable-gpu",
      "--no-sandbox",
      `--print-to-pdf=${pdfPath}`,
      "--no-pdf-header-footer",
      toFileUrl(htmlPath),
    ],
    { encoding: "utf8" },
  );

  if (result.status !== 0) {
    console.error(`Error generando ${pdfPath}`);
    console.error(result.stderr || result.stdout);
    process.exit(result.status ?? 1);
  }

  console.log(`OK: ${pdfPath}`);
}
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
