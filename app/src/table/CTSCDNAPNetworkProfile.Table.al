table 6086228 "CTS-CDN AP Network Profile"
{
    Caption = 'Access Point Network Profiles';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Access Point Name"; Text[250])
        {
            Caption = 'Access Point Name';
        }
        field(3; "Access Point Email"; Text[100])
        {
            Caption = 'Access Point Email';
        }
        field(4; "Access Point URL"; Text[250])
        {
            Caption = 'Access Point URL';
        }
        field(5; "Network Profile ID"; Integer)
        {
            Caption = 'Network Profile ID';
        }
        field(10; "Preregistration Supported"; Boolean)
        {
            Caption = 'Preregistration Supported';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Network Profile ID")
        {
        }
    }

    fieldgroups
    {
    }


    procedure GetDescription(): Text[250]
    var
        NetworkProfile: Record "CTS-CDN Network Profile";
    begin
        if NetworkProfile.Get("Network Profile ID") then
            exit(NetworkProfile.Description);
    end;


    procedure GetGroupDescription(): Text[250]
    var
        NetworkProfile: Record "CTS-CDN Network Profile";
        NetworkProfileGroup: Record "CTS-CDN Network Profile Group";
    begin
        if NetworkProfile.Get("Network Profile ID") then
            if NetworkProfileGroup.Get(NetworkProfile."Network Name", NetworkProfile."Network Profile Group Code") then
                exit(NetworkProfileGroup.Description);
    end;
}

