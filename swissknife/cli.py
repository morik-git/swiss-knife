from __future__ import annotations

from typing import List

import typer

from .csv_tools import concat_csv, join_csv

app = typer.Typer(no_args_is_help=True)
csv_app = typer.Typer(no_args_is_help=True)

app.add_typer(csv_app, name="csv")


@csv_app.command("concat")
def csv_concat(
    inputs: List[str] = typer.Argument(..., help="Input CSV paths"),
    output: str = typer.Option(..., "--output", "-o", help="Output CSV path"),
) -> None:
    concat_csv(inputs, output)
    typer.echo(f"written: {output}")


@csv_app.command("join")
def csv_join(
    left: str = typer.Option(..., "--left", help="Left CSV path"),
    right: str = typer.Option(..., "--right", help="Right CSV path"),
    on: str = typer.Option(..., "--on", help="Join key column"),
    how: str = typer.Option("inner", "--how", help="Join type: inner/left/right/outer"),
    output: str = typer.Option(..., "--output", "-o", help="Output CSV path"),
) -> None:
    join_csv(left, right, on, how, output)
    typer.echo(f"written: {output}")
