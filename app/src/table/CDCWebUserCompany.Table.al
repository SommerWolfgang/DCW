table 6086006 "CDC Web User Company"
{
    Caption = 'Web User Company';
    DataPerCompany = false;

    fields
    {
        field(1; "Company Code"; Code[10])
        {
            Description = 'To Be Deprecated';
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(3; "No. of Documents for Approval"; Integer)
        {
            Caption = 'No. of Documents for Approval';
        }
        field(4; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(5; "No. of Shared Documents"; Integer)
        {
            Caption = 'No. of Shared Documents';
        }
        field(10; "Company GUID"; Guid)
        {
            Caption = 'Company GUID';
        }
    }

    keys
    {
        key(Key1; "User ID", "Company Code", "Company GUID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

