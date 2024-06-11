table 6086225 "CTS-CDN Participation"
{
    Caption = 'Participation';

    fields
    {
        field(1; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
            TableRelation = "CTS-CDN Network";
        }
        field(2; "Identifier Type ID"; Integer)
        {
            Caption = 'Identifier Type ID';
            TableRelation = "CTS-CDN Participation ID Type"."System ID" where("Network Name" = field("Network Name"));
        }
        field(3; "Identifier Value"; Text[50])
        {
            Caption = 'Identifier Value';
        }
        field(10; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
        }
        field(11; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(12; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(13; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(14; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
        }
        field(15; "Your Name"; Text[100])
        {
            Caption = 'Your Name';
        }
        field(16; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
        }
        field(17; "Contact Phone No."; Text[30])
        {
            Caption = 'Contact Phone No.';
        }
        field(18; "Contact Email"; Text[80])
        {
            Caption = 'Contact Email';
        }
        field(19; "Publish in Registry"; Boolean)
        {
            Caption = 'Publish data in Registry';
        }
        field(20; "Registration Status"; Option)
        {
            Caption = 'Registration Status';
            OptionCaption = 'Draft,Pending approval,Connected,Rejected,Disabled';
            OptionMembers = Draft,InProcess,Connected,Rejected,Disabled;
        }
        field(30; "CDN GUID"; Guid)
        {
            Caption = 'CDN GUID';
        }
        field(31; Created; DateTime)
        {
            Caption = 'Created Date-Time';
        }
        field(32; Updated; DateTime)
        {
            Caption = 'Updated Date-Time';
        }
        field(33; "CDN Timestamp"; Text[250])
        {
            Caption = 'CDN Timestamp';
        }
        field(34; "Published in Registry"; Boolean)
        {
            Caption = 'Published in Registry';
        }
    }

    keys
    {
        key(Key1; "Network Name", "Identifier Type ID", "Identifier Value")
        {
            Clustered = true;
        }
        key(Key2; "CDN GUID")
        {
        }
    }
    procedure AddNetworkProfileRelation(NetworkProfileId: Integer; Direction: Option Outbound,Inbound,Both; DocCategoryCode: Code[20])
    begin
    end;

    procedure ModifyNetworkProfileRel(NetworkProfileId: Integer; Direction: Option Outbound,Inbound,Both; DocCategoryCode: Code[20])
    begin
    end;

    procedure DeleteAllNetworkProfileRel()
    begin
    end;

    procedure FilterProfileRelations(var CDNParticipProfileRel: Record "CTS-CDN Particip. Profile Rel.")
    begin
        CDNParticipProfileRel.SetRange("Network Name", "Network Name");
        CDNParticipProfileRel.SetRange("Participation Identifier Type", "Identifier Type ID");
        CDNParticipProfileRel.SetRange("Participation Identifier Value", "Identifier Value");
    end;


    procedure FilterProfileSelections(var CDNProfileSelection: Record "CTS-CDN Profile Sel. Parameter")
    begin
        CDNProfileSelection.SetRange("Network Name", "Network Name");
        CDNProfileSelection.SetRange("Participation Identifier Type", "Identifier Type ID");
        CDNProfileSelection.SetRange("Participation Identifier Value", "Identifier Value");
    end;


    procedure GetSchemeId(): Text[50]
    var
        CDNParticipantIDType: Record "CTS-CDN Participation ID Type";
    begin
        CDNParticipantIDType.Get("Identifier Type ID");
        exit(CDNParticipantIDType."Scheme ID");
    end;


    procedure GetId(): Text[4]
    var
        CDNParticipantIDType: Record "CTS-CDN Participation ID Type";
    begin
        CDNParticipantIDType.Get("Identifier Type ID");
        exit(CDNParticipantIDType."Identifier Type ID");
    end;


    procedure ValidateCDNStatus(CDNStatus: Text[1024])
    begin
        case CDNStatus of
            'DraftEnum':
                Validate("Registration Status", "Registration Status"::Draft);
            'InProcessEnum', 'ApprovedEnum', 'SuspendedEnum', 'ErrorEnum':
                Validate("Registration Status", "Registration Status"::InProcess);
            'ConnectedEnum':
                Validate("Registration Status", "Registration Status"::Connected);
            'RejectedEnum':
                Validate("Registration Status", "Registration Status"::Rejected);
            'DisabledEnum':
                Validate("Registration Status", "Registration Status"::Disabled);
        end;
    end;


    procedure GetParticipApiStatusEnumValue(Suspended: Boolean): Text[1024]
    begin
        if Suspended then
            exit('SuspendedEnum');

        case "Registration Status" of
            "Registration Status"::Draft:
                exit('DraftEnum');
            "Registration Status"::InProcess:
                exit('InProcessEnum');
            "Registration Status"::Connected:
                exit('ConnectedEnum');
            "Registration Status"::Rejected:
                exit('RejectedEnum');
            "Registration Status"::Disabled:
                exit('DisabledEnum');
        end;
    end;


    procedure GetDisplayName(): Text[1024]
    var
        Network: Record "CTS-CDN Network";
    begin
        Network.Get("Network Name");

        exit(StrSubstNo('%1 - [%2] %3', Network."Display Name", GetSchemeId(), "Identifier Value"));
    end;
}

