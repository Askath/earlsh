-module(utils).

-export([stop/0]).

stop() ->
  init:stop(0).
