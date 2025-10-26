DIR=~
PATHSE=$DIR/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')
slurp | grim -g - $PATHSE

copyq copy image/png - < $PATHSE

notify-send 'screenshot made' "saved to $DIR"
