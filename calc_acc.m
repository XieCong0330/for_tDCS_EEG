function acc = calc_acc(tbl,x_test,y_test)
predictions = predict(tbl,x_test);
k = 0;
for i = 1:size(y_test,1)
    if y_test(i,1) == predictions(i,1)
        k = 1+k;
    end
end
acc = k/i;
end