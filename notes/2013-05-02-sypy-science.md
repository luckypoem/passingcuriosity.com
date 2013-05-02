**PANDAS: Python has R Envy** by Eugene Van den Bulke.

Numpy is a multi-dimensional array object. Vectorisation. Very fast.

> "hettingeresque" as a word.

Numpy is typed; integer overflow will happen; declare types:

    number.array([...], dtype="dfloat64")

Universal function are functions which apply (differently?) to scalar and
array values. Is this like J verbs?

    mod = array([...]).mod(2)

    mod != 1

`scikit.timeseries` was the reference implementation of time series in Python.
`pandas` is 

    import pandas

    # A series of 5 values, a=1, b=2, etc.
    series = pandas.Series([1,2,3,4,5], index=list("abcde"), name="demo")

    another = pandas.Series(...)

    series / another

    # Performs the operation for pairs in the intersection of the indexes. NaN
    # for other indexes.

    _.fillna(method='bfill') # Backfill, replacing NaN with next value.

    _.describe() # returns some characteristics of the data (card, mean, etc.)

Also includes a pleasant wrapper around `matplotlib`. And isn't iPython
Notebook awesome.

**Dataframes** is something like a dictionary of series. Turns series into a
table with multiple columns (each series is a column).

Has similar operations as series do (fill, describe, etc.).

plot can do subplots (one per series in the frame).

**Panel** is something like a dictionary of dataframes.

I/O support:

    pandas.io.ga # Load Google Analytics data.

Also has relational-style operations (`.groupby(fn)`)

The pandasql package provides an SQL-like interface to pandas. Running queries
goes via SQLite.

Pandas includes basic linear regression, use statsmodels for more complet
models. scikit-learn and sklearn-pandas.
