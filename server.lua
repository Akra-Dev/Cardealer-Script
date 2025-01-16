ESX = nil

TriggerEvent(Config.Get.ESX, function(obj) ESX = obj end)

-- MYSQL
local Lite = {};
function Lite:Logs(Executed, Message)
    local Started = Executed;
end
LiteMySQL = {};
local Select = {};
local Where = {}
local Wheres = {}
function LiteMySQL:Insert(Table, Content)
    local executed = GetGameTimer();
    local fields = "";
    local keys = "";
    local id = nil;
    for key, _ in pairs(Content) do
        fields = string.format('%s`%s`,', fields, key)
        key = string.format('@%s', key)
        keys = string.format('%s%s,', keys, key)
    end
    MySQL.Async.insert(string.format("INSERT INTO %s (%s) VALUES (%s)", Table, string.sub(fields, 1, -2), string.sub(keys, 1, -2)), Content, function(insertId)
        id = insertId;
    end)
    while (id == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^2INSERT %s', Table))
    if (id ~= nil) then
        return id;
    else
        error("InsertId is nil")
    end
end
function LiteMySQL:Update(Table, Column, Operator, Value, Content)
    local executed = GetGameTimer();
    self.affectedRows = nil;
    self.keys = "";
    self.args = {};
    for key, value in pairs(Content) do
        self.keys = string.format("%s`%s` = @%s, ", self.keys, key, key)
        self.args[string.format('@%s', key)] = value;
    end
    self.args['@value'] = Value;
    local query = string.format("UPDATE %s SET %s WHERE %s %s @value", Table, string.sub(self.keys, 1, -3), Column, Operator, Value)
    MySQL.Async.execute(query, self.args, function(affectedRows)
        self.affectedRows = affectedRows;
    end)
    while (self.affectedRows == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^4UPDATED %s', Table))
    if (self.affectedRows ~= nil) then
        return self.affectedRows;
    end
end
function LiteMySQL:UpdateWheres(Table, Where, Content)
    local executed = GetGameTimer();
    self.affectedRows = nil;
    self.keys = "";
    self.content = "";
    self.args = {};
    for key, value in pairs(Content) do
        self.content = string.format("%s`%s` = @%s, ", self.content, key, key)
        self.args[string.format('@%s', key)] = value;
    end
    for _, value in pairs(Where) do
        self.keys = string.format("%s `%s` %s @%s AND ", self.keys, value.column, value.operator, value.column)
        self.args[string.format('@%s', value.column)] = value.value;
    end
    local query = string.format('UPDATE %s SET %s WHERE %s', Table, string.sub(self.content, 1, -3), string.sub(self.keys, 1, -5));
    MySQL.Async.execute(query, self.args, function(affectedRows)
        self.affectedRows = affectedRows;
    end)
    while (self.affectedRows == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^4UPDATED %s', Table))
    if (self.affectedRows ~= nil) then
        return self.affectedRows;
    end
end
function LiteMySQL:Select(Table)
    self.SelectTable = Table
    return Select;
end
function LiteMySQL:GetSelectTable()
    return self.SelectTable;
end
function Select:All()
    local executed = GetGameTimer();
    local storage = nil;
    MySQL.Async.fetchAll(string.format('SELECT * FROM %s', LiteMySQL:GetSelectTable()), { }, function(result)
        if (result ~= nil) then
            storage = result
        end
    end)
    while (storage == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^5SELECTED ALL %s', LiteMySQL:GetSelectTable()))
    return #storage, storage;
end
function Select:Delete(Column, Operator, Value)
    local executed = GetGameTimer();
    local count = 0;
    MySQL.Async.execute(string.format('DELETE FROM %s WHERE %s %s @value', LiteMySQL:GetSelectTable(), Column, Operator), { ['@value'] = Value }, function(affectedRows)
        count = affectedRows
    end)
    while (count == 0) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^8DELETED %s WHERE %s %s %s', LiteMySQL:GetSelectTable(), Column, Operator, Value))
    return count;
end
function Select:GetWhereResult()
    return self.whereStorage;
end
function Select:GetWhereConditions(Id)
    return self.whereConditions[Id or 1];
end
function Select:GetWheresResult()
    return self.wheresStorage;
end
function Select:GetWheresConditions()
    return self.wheresConditions;
end
function Select:Where(Column, Operator, Value)
    local executed = GetGameTimer();
    self.whereStorage = nil;
    self.whereConditions = { Column, Operator, Value };
    MySQL.Async.fetchAll(string.format('SELECT * FROM %s WHERE %s %s @value', LiteMySQL:GetSelectTable(), Column, Operator), { ['@value'] = Value }, function(result)
        if (result ~= nil) then
            self.whereStorage = result
        end
    end)
    while (self.whereStorage == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^5SELECTED %s WHERE %s %s %s', LiteMySQL:GetSelectTable(), Column, Operator, Value))
    return Where;
end
function Where:Update(Content)
    if (self:Exists()) then
        local Table = LiteMySQL:GetSelectTable();
        local Column = Select:GetWhereConditions(1);
        local Operator = Select:GetWhereConditions(2);
        local Value = Select:GetWhereConditions(3);
        LiteMySQL:Update(Table, Column, Operator, Value, Content)
    else
        error('Not exists')
    end
end
function Where:Exists()
    return Select:GetWhereResult() ~= nil and #Select:GetWhereResult() >= 1
end
function Where:Get()
    local result = Select:GetWhereResult();
    return #result, result;
end
function Select:Wheres(Table)
    local executed = GetGameTimer();
    self.wheresStorage = nil;
    self.keys = "";
    self.args = {};
    for key, value in pairs(Table) do
        self.keys = string.format("%s `%s` %s @%s AND ", self.keys, value.column, value.operator, value.column)
        self.args[string.format('@%s', value.column)] = value.value;
    end
    local query = string.format('SELECT * FROM %s WHERE %s', LiteMySQL:GetSelectTable(), string.sub(self.keys, 1, -5));
    MySQL.Async.fetchAll(query, self.args, function(result)
        if (result ~= nil) then
            self.wheresStorage = result
        end
    end)
    while (self.wheresStorage == nil) do
        Citizen.Wait(1.0)
    end
    Lite:Logs(executed, string.format('^5SELECT %s WHERE %s', LiteMySQL:GetSelectTable(), json.encode(self.args)))
    return Wheres;
end
function Wheres:Exists()
    return Select:GetWheresResult() ~= nil and #Select:GetWheresResult() >= 1
end
function Wheres:Get()
    local result = Select:GetWheresResult();
    return #result, result;
end
--MYSQL
ESX.RegisterServerCallback('akra:getcategories', function(src, cb)
   local allcategories = {}
   MySQL.Async.fetchAll("SELECT * FROM vehicle_categories WHERE society = @society", {
    ["@society"] = "cardealer"
   }, function (result)
        for i = 1, #result , 1 do
            table.insert(allcategories, {
                name = result[i].name,
                label = result[i].label,
                society = result[i].society
            })
        end
        cb(allcategories)
   end)
end)
ESX.RegisterServerCallback('akra:getvehicle', function(src, cb, catname)
    local allveh = {}
    MySQL.Async.fetchAll("SELECT * FROM vehicles WHERE category = @category", {
        ["@category"] = catname
    }, function (result)
         for i = 1, #result , 1 do
             table.insert(allveh, {
                 model = result[i].model,
                 name = result[i].name,
                 price = result[i].price,
             })
         end
         cb(allveh)
    end)
end)
ESX.RegisterServerCallback('vehicle:verifierplaquedispoboutique', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)
RegisterNetEvent("akra:buyvehicle")
AddEventHandler("akra:buyvehicle", function (name, model, price)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local prix = price
    print(prix)
    local plate = CreateRandomPlateText()
    local coords = GetEntityCoords(GetPlayerPed(source));
	local distance = #(coords - vector3(-35.2061, -1108.5896, 26.4170))
    if (distance < 35) then
        if xPlayer.getAccount('bank').money >= prix then
                    LiteMySQL:Insert('owned_vehicles', {
                        owner = xPlayer.identifier,
                        plate = plate,
                        vehicle = json.encode({ model = GetHashKey(model), plate = plate }),
                        type = 'car',
                        state = 1,
                        stored = 1,
                        carseller = 1,
                    })
                    LiteMySQL:Insert('open_car', {
                        owner = xPlayer.identifier,
                        plate = plate
                    });
                    ESX.GiveCarKey(xPlayer, plate, true);
                    xPlayer.removeAccountMoney('bank', prix)
                    TriggerClientEvent('esx:showNotification', source,"Vous avez acheté : " .. name .. " au Concessionnaire !")
        else 
            TriggerClientEvent('esx:showNotification', source,"Vous n'avez pas assez d'argent en banque !")
        end
    end
    
end)
local characters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
function CreateRandomPlateText()
    local plate = ""
    math.randomseed(GetGameTimer())
    for i = 1, 4 do
        plate = plate .. characters[math.random(1, #characters)]
    end
    plate = plate .. ""
    for i = 1, 4 do
        plate = plate .. math.random(1, 9)
    end
    return plate
end
