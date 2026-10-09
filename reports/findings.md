# Mountain Peak Outfitters Findings
These results use the sample data from the assignment. Sales totals come from the transaction records, and category revenue is calculated by multiplying the quantity sold by the price. All amounts use the dataset’s currency.




1. **Low stock:** Six products have fewer than 20 items: Trailblazer Hiking Boot (0), Orphan Product (5), Everest Tent 4-Person (8), NavPro GPS Device (10), Campfire Portable Stove (15), and Pathfinder 55L Backpack (18).

2. **Out of stock:** Trailblazer Hiking Boot is the only product with a stock quantity of zero.
3. **Profit margins:** Adventure Water Bottle has the highest margin at about 79.99%. EcoTrek Water Bottle is a very close second, also rounding to 79.99% at two decimal places.

4. **Missing product links:** Orphan Product has neither a category nor a supplier assigned.

5. **Product/category/supplier list:** The left joins return all 16 products; the Orphan Product row remains present with null category and supplier names.

6. **Sales by store:** Denver leads with 1,624.89, followed by Seattle (1,384.93), Boston (1,234.92), Chicago (1,054.94), Miami (929.97), and Portland (299.99). Austin, Nashville, Minneapolis, and Empty Store have no sales in the sample.

7. **Monthly 2023 sales:** January 1,614.90 across 4 transactions; February 1,349.93 across 4; March 759.96 across 3; April 754.95 across 3; May 1,749.91 across 5; June 299.99 across 1. No later 2023 transactions appear in the data.

8. **Category revenue:** Tents lead at 1,899.94, then Jackets (1,059.95), GPS Devices (749.97), Backpacks (549.97), and Hiking Boots (459.97). Empty Category has no revenue.

9. **Top five products by units:** EcoTrek Water Bottle (11), Expedition 3-Person Tent (4), Alpine Waterproof Jacket (3), NavPro GPS Device (3), and TrailSupport Hiking Poles (3). The query uses product name to break the tie at three units.
10. **Customer purchase history:** The query returns all 11 customers with purchase counts and latest purchase timestamps. Non-purchasing Customer has zero purchases and no latest-purchase date.

11. **Total customer spend:** Alex Roberts is highest at 1,009.95, followed by Ava King (989.95), Sophia Walker (899.95), Emma Young (874.97), and Olivia Clark (729.96). Non-purchasing Customer totals zero.

12. **Average ratings by tier:** Silver averages 4.17, Gold 3.86, None 4.00, and Bronze 3.67. These are descriptive averages from a small sample and do not establish that loyalty tier causes rating differences.

13. **Purchasers without reviews:** None are returned; every customer with a sale has at least one review in the supplied data.

14. **Q2 spending greater than Q1:** Charlotte Scott (0.00 to 399.98), Emma Young (374.98 to 499.99), Jacob Allen (174.98 to 279.98), and Matthew Wright (129.99 to 179.99).

15. **Gold-tier favorite categories:** Using total units purchased, Hiking Boots, Jackets, Tents, and Water Bottles tie at 2 units each.

16. **Employee sales:** Among employees whose role is Sales Associate, Robert Taylor leads at 854.96 across 2 transactions, followed by Jessica Davis (719.95 across 2) and Laura Jackson (679.96 across 2). The SQL also reports every other employee, including those with no assigned sales.

17. **Average transaction value:** William White has the highest average at 499.99 from one transaction. Robert Taylor averages 427.48 across two transactions.

18. **Store staffing and sales:** Denver has manager John Smith, 4 employees, and 1,624.89 in sales; Seattle has David Wilson, 3, and 1,384.93; Boston has Jennifer Anderson, 3, and 1,234.92; Miami has William White, 2, and 929.97; Chicago has James Martin, 3, and 1,054.94. Portland has a 299.99 sale but no employee or manager row; the other four stores have no staff and no sales.

19. **Store salary averages:** The company-wide employee average is 52,968.75. Seattle averages 53,000.00, Boston 53,833.33, Miami 61,500.00, and Chicago 54,666.67, so those four stores exceed the company average.

20. **Product performance matrix:** To make the assignment's high/low cutoffs explicit, high sales is at least the median positive unit volume (2 units), and high margin is at least the median product margin (about 53.59%). Stars: Adventure Water Bottle, Alpine Waterproof Jacket, EcoTrek Water Bottle, Mountain Explorer Jacket, Summit Sleeping Bag, and TrailSupport Hiking Poles. Volume Drivers: Campfire Portable Stove, Everest Tent 4-Person, Expedition 3-Person Tent, NavPro GPS Device, TrailMaster Hiking Boot, and Wilderness 65L Backpack. Opportunities: Basecamp Sleeping Bag and Orphan Product. Problems: Pathfinder 55L Backpack and Trailblazer Hiking Boot.

21. **Management hierarchy:** The sample has five stores with store managers. The recursive query lists each manager and their direct reports, while guarding against accidental cycles. The remaining stores have no manager records in the sample.

22. **Loyalty-tier purchasing summary:** Average transaction value is Bronze 281.65, Gold 337.84, None 399.98, and Silver 345.81. By unit count, Bronze most purchases Water Bottles (5); Gold ties across Hiking Boots, Jackets, Tents, and Water Bottles (2 each); None ties Camp Stoves and Jackets (1 each); Silver most purchases Water Bottles (6). Distinct products reviewed are Bronze 6, Gold 5, None 2, and Silver 5. The query also returns review-row counts so null product references do not inflate distinct-product counts.
