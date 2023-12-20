# Twister RPi workflow

The `twister-rpi.yaml` workflow performs the same project setup as `build.yaml` does before it
starts executing the following `make` commands:

```bash
make install-dep
make project-setup
make test-remote
make test-report-ci     # Runs always, even if "make test-remote" failed
```

Expected behaviour of the `make` commands (those that weren't already described
above):

- `make test-remote` - Runs tests on board connected to a remote J-Link via Raspberry Pi.
- `make test-report-ci` - Creates test report. Runs always, even if `make test`
  failed.
- `make coverage-report-ci` - Creates coverage report.

### Artefacts and reports

Workflow will then:

- Publish test report

To see the test report you can click `Details` (next to any Twister check in the
PR) -> `Summary`.

Artefact `test-report` will also contain `test-report.html` which can be viewed
in browser.
