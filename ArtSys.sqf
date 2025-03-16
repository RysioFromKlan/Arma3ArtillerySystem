artFire ={

	params ["_target", "_art","_know"];	
	
	_randomPosAroundPlayer = [[[position _target, 50/_know]],[]] call BIS_fnc_randomPos;		
	_art commandArtilleryFire [
	_randomPosAroundPlayer,
	getArtilleryAmmo [_art] select 0,  1
	];

};

TryShoot = 
{
	params ["_target","_ao", "_art"];	

	//Check if target in vehicle
	if !(isNull objectParent _target) then
	{
			//Target In vehicle
			_vec = vehicle player;
			_knowledge = _ao knowsAbout _Vec;
			//artillery will only attack light vehicle
			if(_vec iskindof "man" or _vec iskindof "car" or _vec iskindof "StaticWeapon") then
			{
				
				if ( [_vec,150] call CheckForFriendlyFire ) then
				{
					//hint str ("FFV");					
				}
				else
				{
					[_target,_art,_knowledge] call artFire
					//hint str ("SHOOT");
				}				
			}
			//artillery will not shoot at tanks
			else
			{
				//hint str ("NOT SHOOT");
			};
			
			//systemChat str _knowledge;
			
	}
	// Target not in vehicle
	else
	{
			//Target not In vehicle
			hint "false";
			_knowledge = _ao knowsAbout _target;
			_vec = vehicle _target;
			if ( [_vec,150] call CheckForFriendlyFire ) then
			{
				//hint str ("FFI");
			}
			else
			{
				//hint str ("SHOOT");
				[_target,_art,_knowledge] call artFire
			};
			
			//systemChat str _knowledge;			
	};			
};

CheckForFriendlyFire = 
{		
	private _targerPos = _this select 0;
	private _dangerClose = _this select 1;
	
	_list = _targerPos nearEntities [["Car", "Man"], _dangerClose];
	_return = false;
	{
		if (side _x == independent) exitWith {_return = true};
	} forEach _list;
	_return;
};

DebugShoot = 
{
	params ["_ao", "_art"];
	_ao reveal [player, 4];
	_knowledge = _ao knowsAbout player;
	
	 hint str (_knowledge);
	[player,_ao,_art] call TryShoot;
};


