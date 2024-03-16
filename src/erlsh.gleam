import gleam/erlang
import gleam/erlang/charlist
import gleam/io
import gleam/list
import gleam/string.{append, split, trim}
import gleam/result.{is_ok, unwrap}

@external(erlang, "file", "get_cwd")
fn get_cwd() -> Result(String, String)

@external(erlang, "os", "cmd")
fn execute(cmd: charlist.Charlist) -> String

pub fn main() {
  loop()
}

fn loop() {
  let current_working_dir = unwrap(get_cwd(), "")
  let prompt = append(to: current_working_dir, suffix: " > ")
  let user_input = erlang.get_line(prompt)

  case is_ok(user_input) {
    True -> {
      let input = unwrap(user_input, "")
      case trim(input) != "exit" {
        True -> {
          let tokens = split(input, " ")
          unwrap(list.first(tokens), "")
          |> trim()
          |> charlist.from_string()
          |> execute()
          |> io.println()

          loop()
        }
        False -> io.println("Bye")
      }
    }
    False -> io.println("Error")
  }
}
