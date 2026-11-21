# Hand-made pipeline inputs

- `goethe_a1.txt`, `goethe_a2.txt`, `goethe_b1.txt`: one German lemma per line,
  taken from the free Goethe-Institut word lists. These are only used to tag a
  word's level. Do not copy the lists' example sentences or definitions.
- `<level>_extras.json`: grammar points, reading texts and writing prompts
  written by hand for a level, merged in by `08_publish.py`. Same shape as the
  matching arrays in the level file.
