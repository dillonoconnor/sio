# SIO

**Sio** is an Elixir package that allows you to redirect logs
that would typically go to `stdout` into a separate terminal
tab. This is useful for keeping your primary terminal output
clean and organized, while still being able to view logs in a
dedicated tab for debugging or monitoring purposes.

With **Sio**, you can easily manage log visibility across
different tabs, streamlining your development workflow.

## Usage

1. Start your main app with a short name:
`iex --sname main@localhost -S mix phx.server`

2. Start your logger in a new tab:
`iex --sname sio@localhost -S mix`

3. Use SIO just like you would with IO functions:

```elixir
SIO.inspect(object)
# OR
SIO.puts(message)
```
