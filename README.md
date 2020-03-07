# GitPair

[![SourceLevel](https://app.sourcelevel.io/github/elixirsc/git-pair.svg)](https://app.sourcelevel.io/github/elixirsc/git-pair)

Automatically adds [`Co-authored-by`](https://git.wiki.kernel.org/index.php/CommitMessageConventions) mark to commits when you're pairing.

### Learn more

- [GitHub Help](https://help.github.com/en/github/committing-changes-to-your-project/creating-a-commit-with-multiple-authors)

## About

This is a experiment created by [ElixirSC](https://www.meetup.com/elixirsc/) meetup group in our Hacking Sessions.

We're porting Golang project [thechutrain/git-pair](https://github.com/thechutrain/git-pair) to Elixir using [Erlang escript](http://erlang.org/doc/man/escript.html).

## Usage

### Initialize

```
git pair init
```

### List Pairs

```
git pair status
```

### Adding Pair

```
git pair add github-username
```

### Removing Pair

```
git pair rm github-username
```

### Stop pairing with everyone

```
git pair stop
```

## How it works

When you run `git pair init`, it will register [`pre-commit` hook](https://github.com/git/git/blob/master/templates/hooks--pre-commit.sample) to wrap calls to our binary that will add `Co-authored-by` stored in `.git/config`.

## Contributing

```
git clone git@github.com:elixirsc/git-pair.git
cd git-pair
mix deps.get
```

### Build

To build `escript` we use [`Mix`](https://hexdocs.pm/mix/master/Mix.Tasks.Escript.Build.html):

```
mix escript.build
```

This will generate a binary file under `_build/git-pair`.

### Backlog

To check our backlog check out our [Project Board](https://github.com/elixirsc/git-pair/projects/1).
