require_relative "../test_helper"

class Neo4jTest < ActionDispatch::IntegrationTest
  include AdapterTest

  def data_source
    "neo4j"
  end

  def test_run
    assert_result [{"hello" => "world"}], "OPTIONAL MATCH () RETURN 'world' AS `hello`"
  end

  def test_audit
    assert_audit "OPTIONAL MATCH () RETURN $var  AS `hello`\n\n{\"var\":\"world\"}", "OPTIONAL MATCH () RETURN {var} AS `hello`", var: "world"
  end

  def test_string
    assert_result [{"hello" => "world"}], "OPTIONAL MATCH () RETURN {var} AS `hello`", var: "world"
  end

  def test_integer
    assert_result [{"hello" => "1"}], "OPTIONAL MATCH () RETURN {var} AS `hello`", var: "1"
  end

  def test_float
    assert_result [{"hello" => "1.5"}], "OPTIONAL MATCH () RETURN {var} AS `hello`", var: "1.5"
  end

  def test_time
    assert_result [{"hello" => "2022-01-01 08:00:00 UTC"}], "OPTIONAL MATCH () RETURN {created_at} AS `hello`", created_at: "2022-01-01 08:00:00"
  end

  def test_nil
    assert_result [{"hello" => nil}], "OPTIONAL MATCH () RETURN {var} AS `hello`", var: ""
  end

  def test_single_quote
    assert_result [{"hello" => "'"}], "OPTIONAL MATCH () RETURN {var} AS `hello`", var: "'"
  end

  def test_double_quote
    assert_result [{"hello" => '"'}], "OPTIONAL MATCH () RETURN {var} AS `hello`", var: '"'
  end

  def test_backslash
    assert_result [{"hello" => "\\"}], "OPTIONAL MATCH () RETURN {var} AS `hello`", var: "\\"
  end

  def test_bad_position
    assert_bad_position "OPTIONAL MATCH () RETURN 'world' AS {var}", var: "hello"
  end
end
