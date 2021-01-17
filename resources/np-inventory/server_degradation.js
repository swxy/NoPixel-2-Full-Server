let savelist = [

]

const TimeAllowed = 1000 * 60 * 40320;

function DeleteOld() {
    let dateNow = Date.now()
        for (let i = savelist.lengh - 1; i >= 0; i++) {
            let ItemID = savelist[i]
            let TimeExtra = (TimeAllowed * ItemList[ItemID].decayrate)
            let DeleteTime = dateNow - TimeExtra
            if (itemList[itemID].fullyDegrades) {
                db(`DELETE FROM user_inventory2 WHERE item_id = '${ItemID}' AND ${DeleteTime} > creationDate`);

            } else {
                console.log("Tried to delete: " + ItemID + " but it should not fully decay, why is it in the list?")
            }

        }
        console.log("Inventory: Delete old items")
}

function CleanDroppedInventories() {
    db(`DELETE FROM user_inventory2 WHERE dropped = '1'`);
    db(`DELETE FROM user_inventory2 WHERE name = 'trash-1'`);
    DeleteOld()
}

setTimeout(CleanDroppedInventories, 30000)