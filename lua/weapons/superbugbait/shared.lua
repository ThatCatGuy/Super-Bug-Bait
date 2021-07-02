SWEP.PrintName	= "Super Bug Bait"
SWEP.Author		= ""
SWEP.Instructions	= "Left mouse: to throw! \nRight Mouse: to say whoops!\n(2 sec cooldown)"
SWEP.Category	= "CatGuy Sweps"
SWEP.Spawnable 	= true
SWEP.AdminOnly	= false
SWEP.Primary.ClipSize 	= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo 	= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"
SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel 	= "models/weapons/v_bugbait.mdl"
SWEP.WorldModel	= "models/weapons/w_bugbait.mdl"
local ShootSound = Sound( "weapons/slam/throw.wav" )

function SWEP:PrimaryAttack()
	self:ThrowBB( "models/weapons/w_bugbait.mdl" )
	if self.Weapon:GetNextPrimaryFire() >= CurTime() then return end
	self.Weapon:SetNextPrimaryFire(CurTime()+2)
end

function SWEP:SecondaryAttack()
        if ( self.SoundPlaying ) then return end
        self.SoundPlaying = true
        timer.Simple(2, function()
                self.SoundPlaying = false -- nil or false will work fine
        end)
        self:EmitSound( "vo/npc/male01/whoops01.wav" )
end

function SWEP:ThrowBB( model_file )
	self:EmitSound( ShootSound )
	if ( CLIENT ) then return end
	local ent	= ents.Create( "prop_physics" )
	if ( !IsValid( ent ) ) then return end
	ent:SetModel( model_file )
	ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 10 ) )
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	if (  !IsValid( phys ) ) then ent:Remove() return end
    local velocity = self.Owner:GetAimVector()
	velocity = velocity * 100000000
	velocity = velocity + ( VectorRand() * 5 )
	phys:ApplyForceCenter( velocity )
	timer.Simple(2,function() ent:Remove() end)
end