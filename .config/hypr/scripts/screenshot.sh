DIR=~
slurp | grim -g - $DIR/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')

notify-send 'screenshot made' "saved to $DIR"
