# encoding: UTF-8
require_relative 'token'
require_relative 'token_parser'

class SyntaxParserError < RuntimeError
end

class Ast
  attr_accessor :left
  attr_accessor :op 
  attr_accessor :right

  def initialize
    @left  = nil
    @right = nil
    @op    = nil
  end

end

# 字句解析器
# 下記のPEGを実装する
# exp    := term(('+'|'-')term)*
# term   := factor(('*'|'/')factor)*
# factor := '('exp')' | RealNumber | Integer

class SyntaxParser
  def initialize token_parser
    @token_parser = token_parser
    @ast = nil
  end

  def next_token
    @token_parser.next_token
  end

  def expression 
    tree_left = term()
    ast = Ast.new()
    ast.left = tree_left

    begin
      @token = next_token()
      if( @token.type == :OP_PLUS || @token.type == :OP_MINUS ) then
        ast.op = @token

        tree_right = term()
        
        ast.right = tree_right
          
        # 演算子を期待
        @token = next_token()
      else

      end
   
    rescue
    ensure
    end
    return ast
  end

  def term
    factor()
  end
  
  def factor
    @token = next_token()
    if @token.type == :L_PAREN  then
      expression()
      
      @token = next_token()
      if @token.type != :R_PAREN then
        raise SyntaxParserError.exception('()の対応に問題があります。')
      end
    elsif @token.type == :REAL || @token.type == :INT  then
      return @token
    else

      s = "解釈できないトークン:#{@token.content} : #{@token.type}"
      raise SyntaxParserError.exception(s)
    end
  end
end



