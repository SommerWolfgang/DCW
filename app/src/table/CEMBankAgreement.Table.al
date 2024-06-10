table 6086315 "CEM Bank Agreement"
{
    Caption = 'Bank Agreement';
    DataCaptionFields = "Bank Code", "Agreement ID";

    fields
    {
        field(1; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            NotBlank = true;
            TableRelation = "CEM Bank";
        }
        field(2; "Agreement ID"; Text[30])
        {
            Caption = 'Agreement ID';
        }
        field(3; "Bank Name"; Text[30])
        {
            CalcFormula = Lookup("CEM Bank".Name WHERE(Code = FIELD("Bank Code")));
            Caption = 'Bank Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "CEM Bank"."Country/Region Code" WHERE(Code = FIELD("Bank Code"));
        }
        field(30; "Activation Status"; Option)
        {
            Caption = 'Activation Status';
            Editable = false;
            OptionCaption = ' ,Pending,Activated,Disabled';
            OptionMembers = " ",Pending,Activated,Disabled;
        }
    }

    keys
    {
        key(Key1; "Bank Code", "Agreement ID", "Country/Region Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure LookupBank()
    var
        CEMBank: Record "CEM Bank";
    begin
        if CEMBank.Get("Bank Code", "Country/Region Code") then;

        if PAGE.RunModal(0, CEMBank) = ACTION::LookupOK then begin
            "Bank Code" := CEMBank.Code;
            "Country/Region Code" := CEMBank."Country/Region Code";
        end;
    end;
}

