#!/usr/bin/env node
/**
 * Install Tesseract skills for Claude Code.
 *
 * Usage:
 *   npx tesseract-skills              # install globally (~/.claude/skills/)
 *   npx tesseract-skills --project    # install in current project (.claude/skills/)
 *   npx tesseract-skills --project /path/to/project
 */
import { cpSync, mkdirSync, readdirSync } from "node:fs";
import { join, resolve } from "node:path";
import { homedir } from "node:os";
import { fileURLToPath } from "node:url";

const __dirname = fileURLToPath(new URL(".", import.meta.url));
const SKILLS_SRC = join(__dirname, "..", "skills");

const args = process.argv.slice(2);

if (args.includes("--help") || args.includes("-h")) {
  console.log(`Usage: tesseract-skills [options]

Install Tesseract architecture skills for Claude Code.

Options:
  --project [path]   Install in project .claude/skills/ (default: current dir)
  --help, -h         Show this help

Without --project, installs globally to ~/.claude/skills/
`);
  process.exit(0);
}

const projectIdx = args.indexOf("--project");
let targetDir;

if (projectIdx !== -1) {
  const projectPath = args[projectIdx + 1] || process.cwd();
  targetDir = join(resolve(projectPath), ".claude", "skills");
} else {
  targetDir = join(homedir(), ".claude", "skills");
}

const skillDirs = readdirSync(SKILLS_SRC, { withFileTypes: true })
  .filter((d) => d.isDirectory())
  .map((d) => d.name);

let installed = 0;
for (const skill of skillDirs) {
  const dest = join(targetDir, skill);
  mkdirSync(dest, { recursive: true });
  cpSync(join(SKILLS_SRC, skill), dest, { recursive: true });
  installed++;
}

console.log(`Installed ${installed} Tesseract skills to ${targetDir}`);
skillDirs.forEach((s) => console.log(`  /  ${s}`));
