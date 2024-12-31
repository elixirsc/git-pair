# GitPair

![Elixir CI](https://github.com/elixirsc/git-pair/workflows/Elixir%20CI/badge.svg)

Automatically adds [`Co-authored-by`](https://git.wiki.kernel.org/index.php/CommitMessageConventions) mark to commits when you're pairing.

### Learn more

-   [GitHub Help](https://help.github.com/en/github/committing-changes-to-your-project/creating-a-commit-with-multiple-authors)

## About

This is an experiment created by [ElixirSC](https://www.meetup.com/elixirsc/) meetup group in our Hacking Sessions.

We're porting Golang project [thechutrain/git-pair](https://github.com/thechutrain/git-pair) to Elixir using [Erlang escript](http://erlang.org/doc/man/escript.html).

## Install

You can install it with `escript.install` from [hex](https://hex.pm/packages/git_pair):

```
mix escript.install hex git_pair
```

**NOTE:** If you use `asdf`, you need to "export" `git-pair` binary to `asdf` recognized binaries `PATH`:

```
asdf reshim elixir
```

If no version was specified it will get the current version.

### Development

If you want to fetch the development version. You can install directly from this repo:

```
mix escript.install github elixirsc/git-pair branch main
```

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

### Backlog

To check our backlog check out our [Project Board](https://github.com/elixirsc/git-pair/projects/1).
