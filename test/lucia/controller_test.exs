defmodule Lucia.ControllerTest do
  use ExUnit.Case
  alias Lucia.Fsm
  import Lucia.Controller

  setup do
    Fsm.start_link
          
    on_exit fn ->
      Fsm.reset
    end

    :ok
  end

  test "should trigger after receiving 3 events with level below 0.1" do
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert Fsm.get == false
    
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert Fsm.get == false
    
    check %{date: "2015-09-02T17:10:03Z", level: 0.055}
    assert Fsm.get == true    
  end

  test "should not trigger after 23:00" do
    check %{date: "2015-09-02T21:10:03Z", level: 0.055}
    assert Fsm.get == false
    
    check %{date: "2015-09-02T22:10:03Z", level: 0.055}
    assert Fsm.get == false
    
    check %{date: "2015-09-02T23:10:03Z", level: 0.055}
    assert Fsm.get == false

    check %{date: "2015-09-02T23:33:03Z", level: 0.055}
    assert Fsm.get == false
  end

  test "should not trigger if started after 23:00" do
    check %{date: "2015-09-02T23:33:03Z", level: 0.055}
    assert Fsm.get == false

    check %{date: "2015-09-02T23:38:03Z", level: 0.055}
    assert Fsm.get == false

    check %{date: "2015-09-02T23:43:03Z", level: 0.055}
    assert Fsm.get == false

    check %{date: "2015-09-02T23:48:03Z", level: 0.055}
    assert Fsm.get == false

    check %{date: "2015-09-02T23:53:03Z", level: 0.055}
    assert Fsm.get == false

    check %{date: "2015-09-02T23:58:03Z", level: 0.055}
    assert Fsm.get == false
  end
end
