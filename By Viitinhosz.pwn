#include <a_samp>
#include <zcmd>
#include <DOF2>
#include <sscanf2>
#include <foreach>
#pragma disablerecursion

#if defined FILTERSCRIPT
#endif

new IDFIXO[MAX_PLAYERS];

new ProxID;

public OnGameModeInit()
{
	new File[150];format(File, sizeof(File), "ProxID.ini");
	if(DOF2_FileExists(File))
	{
		ProxID = DOF2_GetInt(File,"ProxID");
	}
	else{
		DOF2_CreateFile(File);
		DOF2_SetInt(File,"ProxID",0);
		DOF2_SaveFile();
		ProxID = 0;
	}
	return 1;
}

public OnGameModeExit()
{
	DOF2_Exit();
	return 1;
}
stock GetPlayerNome(playerid)
{
	new Nome[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Nome, MAX_PLAYER_NAME);
	return Nome;
}
stock GetPlayerIdfixo(playerid) return IDFIXO[playerid];
stock GetIdfixo()
{
	new ID;
	ProxID ++;
	ID  = ProxID;
	new File[150];format(File, sizeof(File), "ProxID.ini");
	DOF2_SetInt(File,"ProxID",ProxID);
	DOF2_SaveFile();
	return ID;
}
public OnPlayerConnect(playerid)
{
	new File[150];format(File, sizeof(File), "%s.ini",GetPlayerNome(playerid));
	if(DOF2_FileExists(File))
	{
		IDFIXO[playerid] = DOF2_GetInt(File, "IDFIXO");
	}else{
		new ID = GetIdfixo();
		IDFIXO[playerid] = ID;
		DOF2_CreateFile(File);
		DOF2_SetInt(File,"IDFIXO",ID);
		DOF2_SaveFile();
	}
	return 1;
}
public OnPlayerText(playerid, text[]){
	new Float:X,Float:Y,Float:Z; GetPlayerPos(playerid, X,Y,Z);//Sistema De Chat Local Pode Tira
    foreach(Player, i)
    {
        if(IsPlayerConnected(i))
        {
            if(IsPlayerInRangeOfPoint(i, 30.0, X,Y,Z))
            {
                new texto[120]; format(texto, sizeof(texto),"{353535}%s{FFFFFF}[IDFIXO:%d]{00FF00}[VIP]{0080FF}[ADM]{FFFFFF}:%s",GetPlayerNome(playerid),GetPlayerIdfixo(playerid),text);
                SendClientMessage(i, GetPlayerColor(playerid), texto);
            }
        }
    }            
	return 0;
}
public OnPlayerDisconnect(playerid, reason)
{
	new File[150];format(File, sizeof(File), "IdsFixos/%s.ini",GetPlayerNome(playerid));
	if(DOF2_FileExists(File))
	{
		DOF2_SetInt(File,"IDFIXO",IDFIXO[playerid]);
		DOF2_SaveFile();
	}
	return 1;
}
public OnPlayerSpawn(playerid)
{
	new Str[150];format(Str, sizeof(Str), "{00FF32}IDFIXO:{FFFFFF}%d",IDFIXO[playerid]);
	new Text3D:textLabel = Create3DTextLabel(Str, 0x008080FF, 30.0, 40.0, 50.0, 40.0, 0);
    Attach3DTextLabelToPlayer(textLabel, playerid, 0.0, 0.0, 0.7);
    SendClientMessage(playerid, -1, Str);
	return 1;
}

CMD:nid(playerid)
{
	new ID = GetIdfixo();
	IDFIXO[playerid] = ID;
	new Str[150];format(Str, sizeof(Str), "{00FF32}IDFIXO:{FFFFFF}%d",IDFIXO[playerid]);
	SendClientMessage(playerid, -1, Str);
	return 1;
}
