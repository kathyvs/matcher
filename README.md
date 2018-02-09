# name_matcher
A simple gem to search names in the SCA Ordinary and Armorial. It uses standard
regular expressions, but limits a search to just the names. It also can distinguish
between personal names and non-personal names.

## To use:

`gem install name_matcher`

`name_matcher Els.eth`

returns (for example)

`Anna Elsbeth von Zuberbuehler (Artemisia, June 1998)
Barbary Elspeth Ham (Calontir, February 1986)
Catherine Elspeth d'Aix la Chapelle (West, January 1987)
...
`

By default it reads the version of the Ordinary and Armorial found [online](http://heraldry.sca.org/OandA/index.html).

You can also, for offline work, download a copy and store it locally

`name_matcher -f oanda.db`

or

`name_matcher -f oanda.db.gz`

If you want to search for non-personal names use `-n`


Note: The code has no knowledge of the actual rules for conflict in the SCA.
