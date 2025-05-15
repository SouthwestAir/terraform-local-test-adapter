const { execSync } = require("child_process");

const commitAnalyzerConfig = [
  "@semantic-release/commit-analyzer",
  {
    releaseRules: [ // https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-angular
      { type: "chore", release: false }, // "chore:" commit message prefix
      { type: "ci", release: false }, // "ci:" commit message prefix
      { type: "docs", release: false }, // "docs:" commit message prefix
      { type: "refactor", release: false }, // "refactor:" commit message prefix
      { type: "style", release: false }, // "style:" commit message prefix
      { type: "test", release: false }, // "test:" commit message prefix
    ],
  },
]

const execSetVersionNpm = "npm version ${nextRelease.version} --allow-same-version --no-git-tag-version";
const execSetVersionPoetry = "poetry version ${nextRelease.version}";

const execConfig = [
  "@semantic-release/exec",
  {
    verifyReleaseCmd: `${execSetVersionNpm} && ${execSetVersionPoetry}`
  },
]

const releaseNotesGeneratorConfig = "@semantic-release/release-notes-generator"

const githubConfig = [
  "@semantic-release/github",
  {
    failComment: false,
    failTitle: false,
    successComment: false,
  },
]

const gitConfig = [
  "@semantic-release/git",
  {
    assets: [
      "package-lock.json",
      "package.json",
      "pyproject.toml",
    ],
    message: "chore(release): ${nextRelease.version} released\n\n${nextRelease.notes} ",
  },
]


module.exports = {
  branches: [
    {
      name: "main",
      channel: "releases"
    },
  ],
  plugins: [
    commitAnalyzerConfig,
    execConfig,
    releaseNotesGeneratorConfig,
    gitConfig,
    githubConfig,
  ],
  tagFormat: "${version}",
};
