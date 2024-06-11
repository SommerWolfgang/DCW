table 6085756 "CDC Temp. Document"
{
    Caption = 'Document';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document Category Code"; Code[20])
        {
            Caption = 'Document Category Code';
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(5; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(6; "Date/Time"; DateTime)
        {
            Caption = 'Date/Time';
        }
        field(7; Bold; Boolean)
        {
            Caption = 'Bold';
        }
        field(8; Indentation; Integer)
        {
            Caption = 'Indentation';
        }
        field(9; "File Type"; Text[30])
        {
            Caption = 'File Type';
        }
        field(10; "Is Group"; Boolean)
        {
            Caption = 'Is Group';
        }
        field(11; "Allow Modify"; Boolean)
        {
            Caption = 'Allow Modify';
        }
        field(12; "E-Mail GUID"; Guid)
        {
            Caption = 'Email GUID';
        }
        field(20; "Source Table No. Filter"; Integer)
        {
            Caption = 'Source Table No. Filter';
            FieldClass = FlowFilter;
        }
        field(21; "Source No. Filter"; Code[20])
        {
            Caption = 'Source No. Filter';
            FieldClass = FlowFilter;
        }
        field(22; "Source Subtype Filter"; Integer)
        {
            Caption = 'Source Subtype Filter';
            FieldClass = FlowFilter;
        }
        field(23; "Source Ref. No. Filter"; Integer)
        {
            Caption = 'Source Ref. No. Filter';
            FieldClass = FlowFilter;
        }
        field(24; "Source Posting Date Filter"; Date)
        {
            Caption = 'Source Posting Date Filter';
            FieldClass = FlowFilter;
        }
        field(25; "Find Documents Using"; Option)
        {
            Caption = 'Find Documents Using';
            OptionCaption = ' ,Source Record PK,Document Reference,Navigate';
            OptionMembers = " ","Source Record PK","Document Reference",Navigate;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField("Is Group", false);
    end;


    procedure GetUserName(): Text[50]
    var
        ContiniaUser: Record "CDC Continia User";
    begin
        if ContiniaUser.Get("User ID") then
            exit(ContiniaUser.Name);
    end;
}

