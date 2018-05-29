import random

def end_of_game(play_one_more_time):
    try:
        play_one_more_time = int(input('Select 1 to play again or 2 to exit: '))
        if play_one_more_time == 2:
            exit()
    except ValueError:
        print('Please select either 1 or 2')
        end_of_game(play_one_more_time)


def determinewinnings(bet_amount, bet_type, Total, remaining_funds):
    if bet_type == 'h' and Total >= 8:
        print("You bet high and won")
        return remaining_funds + bet_amount
    elif bet_type == 'l' and Total <= 6:
        print("You bet low and won")
        return remaining_funds + bet_amount
    elif bet_type == 's' and Total == 7:
        print("You rolled SEVEN")
        return remaining_funds + (4 * bet_amount)
    else:
        print("Oh no better luck next time")
        return remaining_funds - bet_amount

def getroll():
    roll = random.randint(1, 6)
    return roll


def begin_game():
    remaining_funds = 100
    while True:
        if remaining_funds <= 0:
            print("Looks like your all out of cash bruh")
            exit(0)
        try:
            print('You have $' + str(remaining_funds) + ' to play with')
            bet_amount = int(input("Place your bet. Enter 0 to quit: "))
            if bet_amount < 0 or bet_amount > remaining_funds:
                print("Invalid input please place another bet")
                continue
            elif bet_amount == 0:
                print("You have exited goodbye")
                exit()
            elif bet_amount > 0 and bet_amount <= remaining_funds:
                play_one_more_time = False
                while not play_one_more_time:
                    bet_type = input("Enter H for high, S for sevens and L for low: ").lower()
                    if (bet_type != 's' and
                            bet_type != 'h' and
                            bet_type != 'l'):
                        print("You have entered an invalid letter please try again")
                        continue
                    else:
                        while bet_amount != 0 and remaining_funds > 0:
                            Dice1 = (getroll())
                            Dice2 = (getroll())
                            Total = Dice1 + Dice2
                            print("Dice 1 = " + str(Dice1))
                            print("Dice 2 = " + str(Dice2))
                            print("Therefore you rolled a " + str(Total))
                            if bet_type == 'h':
                                print("So your betting high eh")
                            elif bet_type == 'l':
                                print("So your betting low eh")
                            elif bet_type == 's':
                                print('You bet SEVEN so it is safe to say your feelling lucky.')
                            remaining_funds = determinewinnings(bet_amount, bet_type, Total, remaining_funds)
                            print("You now have $" + str(remaining_funds) + " dollar(s)")
                            end_of_game(play_one_more_time)
                            play_one_more_time = True
                            break
        except ValueError:
            print("Please place a bet based on your remaining funds")
            continue



begin_game()
