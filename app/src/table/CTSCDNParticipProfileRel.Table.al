table 6086226 "CTS-CDN Particip. Profile Rel."
{
    Caption = 'Participation Profile Relation';

    fields
    {
        field(1; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
            TableRelation = "CTS-CDN Network";
        }
        field(2; "Participation Identifier Type"; Integer)
        {
            Caption = 'Participation Identifier Type';
        }
        field(3; "Participation Identifier Value"; Text[50])
        {
            Caption = 'Participation Identifier Value';
        }
        field(4; "Profile System ID"; Integer)
        {
            Caption = 'Profile System ID';
        }
        field(5; "Profile Direction"; Option)
        {
            Caption = 'Profile Direction';
            OptionCaption = 'Outbound,Inbound,Both';
            OptionMembers = Outbound,Inbound,Both;
        }
        field(11; "CDN GUID"; Guid)
        {
            Caption = 'CDN GUID';
        }
        field(12; "DC Document Category"; Code[20])
        {
            Caption = 'Document Category';
        }
        field(20; Disabled; DateTime)
        {
            Caption = 'Disabled Date-Time';
        }
        field(21; Created; DateTime)
        {
            Caption = 'Created Date-Time';
        }
        field(22; Updated; DateTime)
        {
            Caption = 'Updated Date-Time';
        }
        field(30; "Profile Group Code"; Code[20])
        {
            CalcFormula = Lookup("CTS-CDN Network Profile"."Network Profile Group Code" WHERE("System ID" = FIELD("Profile System ID")));
            Caption = 'Profile Group Code';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Network Name", "Participation Identifier Type", "Participation Identifier Value", "Profile System ID")
        {
            Clustered = true;
        }
        key(Key2; "CDN GUID")
        {
        }
        key(Key3; "DC Document Category")
        {
        }
    }

    fieldgroups
    {
    }


    procedure ValidateCDNDirection(CDNDirection: Text[1024])
    begin
        case CDNDirection of
            'BothEnum':
                Validate("Profile Direction", "Profile Direction"::Both);
            'InboundEnum':
                Validate("Profile Direction", "Profile Direction"::Inbound);
            'OutboundEnum':
                Validate("Profile Direction", "Profile Direction"::Outbound);
        end;
    end;


    procedure GetParticipAPIDirectionEnum(): Text[1024]
    begin
        case "Profile Direction" of
            "Profile Direction"::Both:
                exit('BothEnum');
            "Profile Direction"::Inbound:
                exit('InboundEnum');
            "Profile Direction"::Outbound:
                exit('OutboundEnum');
        end;
    end;


    procedure GetParticipation(var CDNParticipation: Record "CTS-CDN Participation")
    begin
        CDNParticipation.SetRange("Network Name", "Network Name");
        CDNParticipation.SetRange("Identifier Type ID", "Participation Identifier Type");
        CDNParticipation.SetRange("Identifier Value", "Participation Identifier Value");
        CDNParticipation.FindFirst;
    end;
}

