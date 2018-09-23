function bool=continuer()
loop=1;
while loop
    reply = input('[y/n]?','s');
    if  strcmp(lower(reply),'y')
        loop=0;
        bool=1;
    elseif strcmp(lower(reply),'n')
        loop=0;
        bool=0;
    elseif isempty(reply)
        fprintf('Enter was pressed, invalid\n');
    else
        fprintf('Invalid reply, please type Y or N\n');
    end
end

end