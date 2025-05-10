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

const execGetVersion = 'if [[ "$CI_COMMIT_REF_PROTECTED" != "true" && -n "$CI_COMMIT_SHORT_SHA" ]]; then VERSION=${nextRelease.version}+$CI_COMMIT_SHORT_SHA; else VERSION=${nextRelease.version}; fi'
const execSetVersionNpm = "npm version $VERSION --allow-same-version --no-git-tag-version";
const execSetVersionPoetry = "poetry version $VERSION";
const execSetVersionLegacyTxtFile = "echo $VERSION > nextversion.txt";
const execConfig = [
  "@semantic-release/exec",
  {
    verifyReleaseCmd: `${execGetVersion} && ${execSetVersionNpm} && ${execSetVersionLegacyTxtFile} && ${execSetVersionPoetry}`
  },
]

const releaseNotesGeneratorConfig = "@semantic-release/release-notes-generator"

const gitlabConfig = [
  "@semantic-release/gitlab",
  {
    failComment: false,
    failTitle: false,
    gitlabUrl: process.env.CI_SERVER_URL,
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
    gitlabConfig,
  ],
  tagFormat: "${version}",
};
