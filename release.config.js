const { execSync } = require("child_process");

var commitAnalyzerConfig = [
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

var execGetVersion = 'if [[ "$CI_COMMIT_REF_PROTECTED" != "true" && -n "$CI_COMMIT_SHORT_SHA" ]]; then VERSION=${nextRelease.version}+$CI_COMMIT_SHORT_SHA; else VERSION=${nextRelease.version}; fi'
var execSetVersionNpm = "npm version $VERSION --allow-same-version --no-git-tag-version";
var execSetVersionPoetry = "poetry version $VERSION";
var execSetVersionLegacyTxtFile = "echo $VERSION > nextversion.txt";
var execConfig = [
  "@semantic-release/exec",
  {
    verifyReleaseCmd: `${execGetVersion} && ${execSetVersionNpm} && ${execSetVersionLegacyTxtFile} && ${execSetVersionPoetry}`
  },
]

var releaseNotesGeneratorConfig = "@semantic-release/release-notes-generator"

var gitlabConfig = [
  "@semantic-release/gitlab",
  {
    failComment: false,
    failTitle: false,
    gitlabUrl: process.env.CI_SERVER_URL,
    successComment: false,
  },
]

var gitConfig = [
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

/**
 * Get the name of current branch if it is a dev branch or "invalid"
 *
 * @return {String} The name of the current branch, "invalid", or "undefined".
 */
function getDevBranchName() {
  try {
    let branch = (
      process.env.CI_COMMIT_BRANCH ||
      process.env.CI_COMMIT_REF_NAME ||
      execSync("git branch --show-current").toString().trim()
    );
    console.log(`Current branch: ${branch}`);
    if (["master", "alpha", "beta"].includes(branch)) {
      console.log(`${branch} branch detected, ignoring dev release channel`);
      return "ignore";
    } else {
      return branch;
    }
  } catch (error) {
    console.log(`failed to get current branch: ${error.message}`);
    return "undefined";
  }
}

module.exports = {
  branches: [
    {
      name: "master",
      channel: "swa-releases"
    },
    {
      name: "alpha",
      channel: "swa-releases",
      prerelease: true
    },
    {
      name: "beta",
      channel: "swa-releases",
      prerelease: true
    },
    {
      name: getDevBranchName(),
      channel: "swa-dev",
      prerelease: "dev",
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
