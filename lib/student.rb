require_relative "../config/environment.rb"
require 'pry'
class Student

  attr_accessor :name, :grade, :id

  def initialize (name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    album TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = <<-SQL
    UPDATE students
    SET name= ?, grade =?
    WHERE id =?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.find_by_name(name)
    sql = <<-SQL
    Select *
    From students
    Where name = ?
    Limit 1
    SQL
    self.new_from_db(DB[:conn].execute(sql, name).flatten)
  end

def self.new_from_db(row)
  new_student = Student.new(row[1],row[2],row[0])
end

def self.create(name,grade)
  new_student = Student.new(name, grade)
  new_student.save
  new_student
end


end
