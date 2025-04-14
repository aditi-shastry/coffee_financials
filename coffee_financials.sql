/* find weekly revenue and cost of goods sold of each item */

#the order_details CTE finds weekly revenue per item 
WITH order_details AS (

SELECT od.item_id, 
i.item_name, 
i.item_size, 
SUM(od.quantity) AS total_ordered, 
i.item_price AS price
FROM orders AS od

INNER JOIN (SELECT item_id, item_name, item_size, item_price FROM items) AS i
 ON od.item_id = i.item_id 
 
GROUP BY od.item_id, i.item_name, i.item_size, i.item_price 
ORDER BY od.item_id
),

/* the cost_of_ingredients CTE and subquery find cost of goods sold (COGS) per item */
cost_of_ingredients AS (
SELECT ingre_details.item_name,
ingre_details.item_size,
ingre_details.recipe_id,

ROUND(SUM(ingre_details.ing_costs),2) AS costs_per_item FROM (
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
 
GROUP BY items.item_name, 
items.item_size, 
r.recipe_id, 
r.ing_id, 
i.ing_name, 
r.quantity, 
i.ing_price, 
i.ing_weight 
ORDER BY items.item_name ASC) AS ingre_details

GROUP BY ingre_details.item_name, ingre_details.item_size, ingre_details.recipe_id)

 
/*the item id, name, size, total ordered, sales price, cost per item
weekly revenue, and weekly cost are displayed */
 
SELECT od.item_id,
od.item_name,
od.item_size,
od.total_ordered,
od.price AS sales_price,
coi.costs_per_item,
CONCAT('$',ROUND((od.total_ordered * 1.0 * od.price),2)) AS weekly_item_revenue,
CONCAT('$',ROUND(od.total_ordered * 1.0 * coi.costs_per_item,2)) AS weekly_item_cost
FROM order_details AS od

INNER JOIN cost_of_ingredients AS coi
 ON od.item_name = coi.item_name AND od.item_size = coi.item_size
 
GROUP BY od.item_id, 
od.item_name, 
od.item_size, 
od.total_ordered, 
od.price, 
coi.costs_per_item 
ORDER BY od.item_id, od.item_name;


