function Trac_out = sm_trackV_belt_contact_geo(Trac,showHide)

Trac_out = Trac;

switch showHide
    case 'show', opc = 0.5;
    case 'hide', opc = 0;
end

Trac_out.Belt.carcass_contact.opc       = opc;
Trac_out.Belt.lug_contact.opc           = opc;
Trac_out.Sprocket.spoke_contact.opc     = opc;
Trac_out.Sprocket.roller_contact.opc    = opc;
Trac_out.IdlerF.belt_contact.opc        = opc;
Trac_out.IdlerR.belt_contact.opc        = opc;
Trac_out.Roller.Lower.belt_contact.opc  = opc;

