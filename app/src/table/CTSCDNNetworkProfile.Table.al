table 6086222 "CTS-CDN Network Profile"
{
    Caption = 'Network Profile';

    fields
    {
        field(1; "System ID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'System ID';
        }
        field(2; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
            TableRelation = "CTS-CDN Network";
        }
        field(3; "Process Identifier"; Text[250])
        {
            Caption = 'Process Identifier';
        }
        field(4; "Document Identifier"; Text[250])
        {
            Caption = 'Document Identifier';
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(6; "Customization ID"; Text[250])
        {
            Caption = 'Customization ID';
        }
        field(10; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
        field(11; "CDN GUID"; Guid)
        {
            Caption = 'CDN GUID';
        }
        field(12; "Network Profile Group Code"; Code[20])
        {
            Caption = 'Network Profile Group Code';
        }
        field(13; Mandatory; Boolean)
        {
            Caption = 'Mandatory';
        }
        field(14; "Mandatory for Country"; Code[50])
        {
            Caption = 'Mandatory for Country';
        }
        field(20; "Filter Code"; Code[20])
        {
            Caption = 'Code';
        }
    }

    keys
    {
        key(Key1; "System ID")
        {
            Clustered = true;
        }
        key(Key2; "CDN GUID")
        {
        }
        key(Key3; "Filter Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Filter Code" := Format("System ID");
    end;


    procedure FindNetworkProfile(NetworkName: Text[30]; ProcessIdentifier: Text[250]; DocumentIdentifier: Text[250])
    begin
    end;

    procedure GetDocumentRootNamespaceUrl() RootNamespaceUrl: Text[1024]
    begin
    end;

    procedure GetDocumentRootNodeName() RootNodeName: Text[1024]
    begin
    end;

    procedure GetDocumentCustomizationId() CustomizationId: Text[1024]
    begin
    end;

    procedure GetDocumentVersion() Version: Text[1024]
    begin
    end;

    procedure IsInvoice(): Boolean
    begin
        if LowerCase(GetDocumentRootNodeName()) = 'invoice' then
            exit(true);
    end;

    procedure IsCreditNote(): Boolean
    begin
        if LowerCase(GetDocumentRootNodeName()) = 'creditnote' then
            exit(true);
    end;
}