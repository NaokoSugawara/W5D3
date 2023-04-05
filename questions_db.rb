require 'sqlite3'
require 'singleton'

require "byebug"

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end


class Question 

    attr_accessor :id, :title, :body, :author_id

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM 
                questions
            WHERE
                id = ?
        SQL
        return nil unless question.length > 0

        Question.new(question.first)
    end
    
    def self.find_by_author_id(author_id)
        
        questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM 
                questions
            WHERE
                author_id = ?
        SQL
        return nil unless questions.length > 0

        questions.map { |question| Question.new(question) }
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def author
        # debugger
        author = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
            SELECT
                *
            FROM 
                users
            WHERE
                id = ?
        SQL
        return nil unless author.length > 0

        User.new(author.first)
    end

    def replies 
        Reply.find_by_question_id(self.id)
    end


end


class User

    attr_accessor :id, :fname, :lname

    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM 
                users
            WHERE
                fname = ? AND lname = ?
        SQL
        return nil unless user.length > 0

        User.new(user.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions
        # debugger 
        quetsions = Question.find_by_author_id(self.id)
        # raise "#{self.id} not found in DB" unless quetsions
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end

end


class Reply

    attr_accessor :id, :reply, :subject_question_id, :parent_reply_id, :author_id

    def self.find_by_user_id(author_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM 
                replies
            WHERE
                author_id = ?
        SQL
        return nil unless replies.length > 0

        replies.map { |reply| Reply.new(reply) }
    end

    def self.find_by_question_id(subject_question_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, subject_question_id)
            SELECT
                *
            FROM 
                replies
            WHERE
                subject_question_id = ?
        SQL
        return nil unless replies.length > 0

        replies.map { |reply| Reply.new(reply) }
    end

    def initialize(options)
        @id = options['id']
        @reply = options['reply']
        @subject_question_id = options['subject_question_id']
        @parent_reply_id = options['parent_reply_id']
        @author_id = options['author_id']
    end

    def author
        user = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
            SELECT
                *
            FROM 
                users
            WHERE
                id = ?
        SQL
        return nil unless user.length > 0

        User.new(user.first)
    end

    def question
        quetsion = QuestionsDatabase.instance.execute(<<-SQL, self.subject_question_id)
            SELECT
                *
            FROM 
                questions
            WHERE
                id = ?
        SQL
        return nil unless quetsion.length > 0

        Question.new(quetsion.first)
    end

    def parent_reply
        parent_reply = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
        SELECT
            *
        FROM 
            replies
        WHERE
            id = ?
        SQL
        return nil unless parent_reply.length > 0

        Reply.new(parent_reply.first)
    end

    def child_replies
        child_replies = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM 
            replies
        WHERE
            parent_reply_id = ?
        SQL
        return nil unless child_replies.length > 0

        child_replies.map { |child_reply| Reply.new(child_reply) }
    end

end

class QuestionFollow

    def self.followers_for_question_id(question_id)

    end

end