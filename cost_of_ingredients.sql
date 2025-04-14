/* find ingredient cost per item, item name, 
item size, and corresponding recipe */

WITH cost_of_ingredients AS (
SELECT ingre_details.item_name,
ingre_details.item_size,
ingre_details.recipe_id,

CONCAT('$',ROUND(SUM(ingre_details.ing_costs),2)) AS costs_per_item FROM (
SELECT 
items.item_name,
items.item_size,
r.recipe_id,
r.ing_id, 
i.ing_name,
r.quantity,
i.ing_price,
i.ing_weight,
ROUND((r.quantity * 1.0 * (i.ing_price*1.0/i.ing_weight)),3) AS ing_costs
FROM recipe AS r

LEFT OUTER JOIN ingredients AS i
 ON r.ing_id = i.ing_id
 
RIGHT OUTER JOIN items 
 ON r.recipe_id = items.sku
 
GROUP BY items.item_name, items.item_size, r.recipe_id, r.ing_id, i.ing_name, r.quantity, i.ing_price, i.ing_weight 
ORDER BY items.item_name ASC) AS ingre_details

GROUP BY ingre_details.item_name, ingre_details.item_size, ingre_details.recipe_id;


 
 
