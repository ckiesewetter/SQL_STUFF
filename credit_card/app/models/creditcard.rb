class Creditcard < ActiveRecord::Base
  belongs_to :owner
end


# ---example
#
# Pakke.sum(:prismd, :conditions => {:id => [4,5]})
#
# Creditcard.sum(:credit_limit) => {id =>[2,3]}
#
# Creditcard.sum(:, :conditions=>'1 = 2')

owner = Owner.find(2)

# yay, we have an Owner!

owner.creditcards
#this behaves like join in sql^^^^
# yay, we have our owner's phones!

owner.creditcards.sum(:credit_limit)
# yay, we get back the added max credit limit!
