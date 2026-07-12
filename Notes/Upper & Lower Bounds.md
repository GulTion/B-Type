Note:
- `upper_bound` and `lower_bound` behave same when finding element is not present in the array
- `upper_bound` give $[1,2,2,2,2,\textbf{3},4]$  for the finding element `2`.
- `lower_bound` give $[1,\textbf{2},2,2,2,3,4]$  for the finding element `2`.
- both will give `arr.end()` if finding element is greater than all the element in the array.

