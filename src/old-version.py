# Ines Simicic, 2013
# https://bitbucket.org/i_s/set
# 0.1.0.5 (alpha) 2013-11-02

# import SimpleGUICS2Pygame.simpleguics2pygame as simplegui
import simplegui
import random
import time

random.seed(10)

set30 = simplegui.load_image("https://dl.dropboxusercontent.com/u/108138136/set/set30.png")
set31 = simplegui.load_image("https://dl.dropboxusercontent.com/u/108138136/set/set31.png")

### constants 
# default tile size
size = 60
# tile dimension
dim = [60, 60]
# (0, 0) in tiles
init = [size/2, size/2]

# max for tiles in imported images
maxx = size * 9
maxy = size * 9

# create 'empty tile'
empty_tile = [maxx, maxy]
empty = [0, True]

# all cards still available go here
deck = []

# cards in game, on board 
board = [[0 for x in range(0, 5)] for x in range(0, 5)]

# possible set, for test
test_set = []
selecting = True

# score stuff
start_time = 0
move_time = 0
end_time = 0
score = 0
sets_found = 0

### helper functions
# start new game
def new_game():
    global deck, start_time, move_time
    global score, sets_found
    init_deck()
    random.shuffle(deck)
    init_board()
    start_time = time.time()
    move_time = start_time
    score = 0
    sets_found = 0
    label_score.set_text("Score: 0")
    label_sets_found.set_text("Sets found: 0")
    
# init deck, 81 cards
def init_deck():
    global deck
    for i in range(0, 3):
        for j in range(0, 3):
            for k in range(0, 3):
                for l in range(0, 3):
                    deck.append([i, j, k, l, 0])

#init board, set for each tile [col, shade, shape, num, select]
# select is 0 or 1 (card selected), others in range (0, 3)
def init_board():
    global in_game, deck
    for i in range(0, 5):
        for j in range(0, 5):
            if i < 3 and j < 4:
                board[i][j] = deck.pop()
            else:
                board[i][j] = empty

# remove if set is found
def remove_if_set(test):
    if is_set(test):
        remove(test)
        add_score (time.time())
        add_new()
        add_sets_found()
    else:
        print "not set"

# test if test_set is set
def is_set(test):
    item = []
    tmp = []
    res = True
    print test_set
    if len(test) < 3:
        res = False
    else:
        item.append(board[test[0][0]][test[0][1]])
        item.append(board[test[1][0]][test[1][1]])
        item.append(board[test[2][0]][test[2][1]])
        for i in range(0, 4):
            tmp.append(item[0][i] + item[1][i] + item[2][i])
            tmp[i] = (tmp[i] % 3) == 0
            res = res and tmp[i]
    return res
    
# remove set from board
def remove(test):
    global board, test_set, selecting
    for item in test:
        board[item[0]][item[1]] = empty
    test_set = []
    selecting = True

# add new cards on board
def add_new():
    global board, deck
    cnt = 0
    if len(deck) > 0:
        for i in range(0, 3):
            for j in range(0, 4):
                if (board[i][j] == empty) and (cnt < 3):
                    board[i][j] = deck.pop()
                    cnt += 1
    if (cnt < 3) and len(deck) > 0:
        for i in range(0, 3):
            if (board[i][4] == empty) and (cnt < 3):
                board[i][4] = deck.pop()
                cnt += 1
    if (cnt < 3) and len(deck) > 0:
        for i in range(3, 5):
            for j in range(0, 5):
                if (board[i][j] == empty) and (cnt < 3):
                    board[i][j] = deck.pop()
                    cnt += 1
    print deck                        
       
# score
def add_score(some_time):
    global move_time, score
    if (some_time - move_time) < 60:
        score += 60 - int(some_time - move_time)
    else:
        score += 1
    print score        
    message = "Score: " + str(score)
    label_score.set_text(message)

# add sets found counter
def add_sets_found():
    global sets_found
    sets_found += 1
    message = "Sets found: " + str(sets_found)
    label_sets_found.set_text(message)
    
# deselect set
def deselect(test):
    pass

# image <-> tile helpers
# return output coordinates - board pos(row, col)
def pos(col, row):
    return [init[0] + row*size, init[1] + col*size]

# return input coordinates - set image [col, shade, shape, num, select]
def pos_set(tile):
    if tile == empty:
        return empty_tile
    else:
        return pos(tile[0]*3 + tile[1], tile[2]*3 + tile[3])


### handlers
# mouse handler, select and deselect tile
def select_tile(position):
    global board, test_set, selecting
    col = position[0] / size
    row = position[1] / size
    if not (board[row][col] == empty):
        if selecting:
            if (board[row][col].pop() == 0):
                board[row][col].append(1)
                test_set.append([row, col])
                if len(test_set) == 3:
                    selecting = False
            else:
                board[row][col].append(0)
                test_set.remove([row, col])
                selecting = True
        elif (board[row][col].pop() == 1):
            board[row][col].append(0)
            test_set.remove([row, col])
            selecting = True
        else:
            board[row][col].append(0)
    if not selecting:
        remove_if_set(test_set)

# draw on canvas
def draw(canvas):
    for i in range(0, 5):
        for j in range (0, 5):
            if (board[i][j][-1] == 0): # is selected = last item in list
                canvas.draw_image (set30, pos_set(board[i][j]), dim, pos(i, j), dim)
            else:
                canvas.draw_image (set31, pos_set(board[i][j]), dim, pos(i, j), dim)

# button 'no sets'
def button_no_sets():
    global move_time, score
    some_time = time.time()
    if (some_time - move_time) < 60:
        score += (60 - int(some_time - move_time)) * 2
    else:    
        score += 10
    message = "Score: " + str(score)
    label_score.set_text(message)
    add_new()

# button 'remove 3' random cards
def button_remove3():
    global board
    cnt = 0
    while (cnt < 3) and not board_empty():
        i = random.randint(0, 4)
        j = random.randint(0, 4)
        if not (board[i][j] == empty):
            board[i][j] = empty
            cnt += 1
    
# is board empty
def board_empty():
    global board
    for i in range(0, 5):
        for j in range(0, 5):
            if not (board[i][j] == empty):
                return False
    return True        
    
### Create a frame and assign callbacks to event handlers
frame = simplegui.create_frame("Find a set", 300, 300)
frame.set_canvas_background('#DDDDDD')
frame.set_mouseclick_handler(select_tile)
frame.add_button("No sets here", button_no_sets, 150)
frame.add_button("Remove 3 cards", button_remove3, 150)
frame.set_draw_handler(draw)
label_score = frame.add_label('Score: 0')
label_sets_found = frame.add_label('Sets found: 0')

### Start the frame animation
new_game()
frame.start()
