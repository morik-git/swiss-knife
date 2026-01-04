from __future__ import annotations

from pathlib import Path
from typing import Iterable

import pandas as pd


def concat_csv(inputs: Iterable[str], output: str) -> Path:
    paths = [Path(p) for p in inputs]
    if not paths:
        raise ValueError("inputs must not be empty")
    frames = [pd.read_csv(p) for p in paths]
    result = pd.concat(frames, ignore_index=True)
    out_path = Path(output)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    result.to_csv(out_path, index=False)
    return out_path


def join_csv(left: str, right: str, on: str, how: str, output: str) -> Path:
    left_df = pd.read_csv(left)
    right_df = pd.read_csv(right)
    result = left_df.merge(right_df, on=on, how=how)
    out_path = Path(output)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    result.to_csv(out_path, index=False)
    return out_path
