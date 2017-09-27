class ApplicationError < RuntimeError
  class Forbidden < ApplicationError; end
  class Unauthorized < ApplicationError; end
  class InvalidData < ApplicationError; end
end
