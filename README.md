# Linear Orb [![CircleCI Build Status](https://circleci.com/gh/linear/linear-release-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/linear/linear-release-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/circleci/linear.svg)](https://circleci.com/developer/orbs/orb/circleci/linear) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/linear/linear-release-orb/master/LICENSE)

Integrates [Linear Releases](https://linear.app/docs/releases) into your CircleCI pipeline. Automatically tracks which issues ship with each deployment.

## Usage

Add the orb and call `linear/sync` after your deploy step. The command requires a `LINEAR_ACCESS_KEY` environment variable — set it in your project settings or a context.

```yaml
version: 2.1

orbs:
  linear: circleci/linear@1.0.0

jobs:
  deploy:
    docker:
      - image: cimg/base:current
    steps:
      - checkout
      - run: ./deploy.sh
      - linear/sync

workflows:
  deploy:
    jobs:
      - deploy
```

For full usage guidelines, see the [Orb Registry listing](https://circleci.com/developer/orbs/orb/circleci/linear).

---

## Testing

### Validate locally

Pack and validate the orb without publishing:

```sh
circleci orb pack src/ > orb.yml
circleci orb validate orb.yml
```

### Publish a dev orb

To test changes in a live pipeline before cutting a release, publish a dev orb manually:

```sh
circleci orb pack src/ > orb.yml
circleci orb publish orb.yml circleci/linear@dev:my-branch
```

Then reference it in a downstream pipeline:

```yaml
orbs:
  linear: circleci/linear@dev:my-branch
```

Dev orbs expire after 90 days and are not suitable for production use.

### Check the current published version

```sh
circleci orb info circleci/linear | grep "Latest"
```

---

## Publishing a Release

Releases are triggered by creating a GitHub Release, which pushes a tag and kicks off the publishing pipeline in CircleCI via `test-deploy.yml`.

1. Merge your pull request into `main` using squash-and-merge. For the best experience, use [Conventional Commit Messages](https://conventionalcommits.org/) — they make it easier to determine the correct version bump.

2. Check the current version:
   ```sh
   circleci orb info circleci/linear | grep "Latest"
   ```

3. Open the [new release page](https://github.com/linear/linear-release-orb/releases/new) on GitHub.

4. Click **"Choose a tag"** and type a new [semantically versioned](https://semver.org/) tag (e.g. `v1.0.1`). Use the following as a guide:
   - `patch` — bug fixes, binary version or SHA bumps
   - `minor` — new commands or parameters, backwards-compatible changes
   - `major` — breaking changes

5. Click **"+ Auto-generate release notes"** to summarise merged pull requests since the last release.

6. Verify the tag is correct, then click **"Publish Release"**. This pushes the tag and triggers the CircleCI publishing pipeline.

Monitor the pipeline at [app.circleci.com](https://app.circleci.com). The `orb-tools/publish` job in `test-deploy.yml` will publish the new version to the orb registry under `circleci/linear`.

---

## Bumping the Binary Version

When a new `linear-release` binary version is available:

1. Update `VERSION` in `src/scripts/install-linear.sh`.

2. Fetch the new SHA256 digests from the GitHub release:
   ```sh
   gh api repos/linear/linear-release/releases/tags/vX.Y.Z \
     --jq '.assets[] | "\(.name): \(.digest)"'
   ```

3. Update the three `EXPECTED_SHA256` values in `src/scripts/install-linear.sh` to match.

4. Open a pull request, merge to `main`, then cut a `patch` release.
