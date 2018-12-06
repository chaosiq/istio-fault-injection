# Demo for KubeCon North America 2018

To install locally the environment, on Linux only, assuming you have
[snap][] installed, run:

[snap]: https://snapcraft.io/

```
$ ./scripts/deploy-local.sh
```

Then install the [Chaos Toolkit][] and dependencies as follows:

```
$ pip install -U --pre -r requirements.txt
```

[chaostoolkit]: https://chaostoolkit.org/

Finally run the experiment as follows:

```
$ chaos run experiments/delay-jason.sh
```

## Contribute

Contributors to this project are welcome as this is an open-source effort that
seeks [discussions][join] and continuous improvement.

[join]: https://join.chaostoolkit.org/

From a code perspective, if you wish to contribute, you will need to run a 
Python 3.5+ environment. Then, fork this repository and submit a PR. The
project cares for code readability and checks the code style to match best
practices defined in [PEP8][pep8]. Please also make sure you provide tests
whenever you submit a PR so we keep the code reliable.

[pep8]: https://pycodestyle.readthedocs.io/en/latest/

The Chaos Toolkit projects require all contributors must sign a
[Developer Certificate of Origin][dco] on each commit they would like to merge
into the master branch of the repository. Please, make sure you can abide by
the rules of the DCO before submitting a PR.

[dco]: https://github.com/probot/dco#how-it-works