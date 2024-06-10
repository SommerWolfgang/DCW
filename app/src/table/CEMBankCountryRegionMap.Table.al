table 6086312 "CEM Bank Country/Region Map"
{
    Caption = 'Bank Country/Region Map';
    DataCaptionFields = "Bank Code", "Bank Country/Region Code";

    fields
    {
        field(1; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            NotBlank = true;
            TableRelation = "CEM Bank";
        }
        field(2; "Bank Country/Region Code"; Code[10])
        {
            Caption = 'Bank Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(3; "Country/Region Code (Bank)"; Code[20])
        {
            Caption = 'Country/Region Code (Bank)';
            NotBlank = true;
        }
        field(10; "Country/Region Code (NAV)"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "CEM Country/Region";
        }
    }

    keys
    {
        key(Key1; "Bank Code", "Bank Country/Region Code", "Country/Region Code (Bank)")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

