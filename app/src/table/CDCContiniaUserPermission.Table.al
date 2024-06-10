table 6085634 "CDC Continia User Permission"
{
    Caption = 'Continia User Permission';
    DataCaptionFields = "Continia User ID", "Approval User Group Code";
    PasteIsValid = false;

    fields
    {
        field(1; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
            TableRelation = "CDC Continia User Setup";
        }
        field(2; "Approval User Group Code"; Code[20])
        {
            Caption = 'Approval User Group Code';
            Editable = false;
            TableRelation = "CDC Approval User Group";
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'G/L Account,Item,,Fixed Asset,Charge (Item),Dimension,Job';
            OptionMembers = "G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",Dimension,Job;
        }
        field(4; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
        }
        field(5; "Assigning Permission"; Option)
        {
            Caption = 'Assigning Permission';
            OptionCaption = ' ,All,Include Selected,Exclude Selected,Filter';
            OptionMembers = " ",All,"Include Selected","Exclude Selected","Filter";
        }
        field(6; "Approval Permission"; Option)
        {
            Caption = 'Approval Permission';
            OptionCaption = ' ,All,Include Selected,Exclude Selected,Filter,Same as Assigning';
            OptionMembers = " ",All,"Include Selected","Exclude Selected","Filter","Same as Assigning";
        }
        field(7; "Assigning Filter"; Code[250])
        {
            Caption = 'Assigning Filter';
        }
        field(8; "Approval Filter"; Code[250])
        {
            Caption = 'Approval Filter';
        }
        field(9; "No. of Assigning Selections"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("CDC Continia User Pms. Sel." WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                                     "Approval User Group Code" = FIELD("Approval User Group Code"),
                                                                     Type = FIELD(Type),
                                                                     "Dimension Code" = FIELD("Dimension Code"),
                                                                     "Permission Type" = CONST("Assigning Permission")));
            Caption = 'No. of Assigning Selections';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "No. of Approval Selections"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("CDC Continia User Pms. Sel." WHERE("Continia User ID" = FIELD("Continia User ID"),
                                                                     "Approval User Group Code" = FIELD("Approval User Group Code"),
                                                                     Type = FIELD(Type),
                                                                     "Dimension Code" = FIELD("Dimension Code"),
                                                                     "Permission Type" = CONST("Approval Permission")));
            Caption = 'No. of Approval Selections';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Continia User ID", Type, "Dimension Code", "Approval User Group Code")
        {
            Clustered = true;
        }
    }
    procedure SetCurrCompanyNameTbl(NewCompanyName: Text[30])
    begin
    end;

    procedure GetCurrCompanyNameTbl(): Text[30]
    begin
    end;

    procedure DrillDownSelection(NewCompanyName: Text[30]; PermissionType: Option "Assigning Permission","Approval Permission")
    begin
    end;

    procedure LookUpPmsFilter(NewCompanyName: Text[30]; PermissionType: Option "Assigning Permission","Approval Permission",Both; var Text: Text[250]): Boolean
    begin
    end;

    procedure GetContiniaUserSetup()
    begin
    end;

    procedure LookUpDimCode(NewCompanyName: Text[30]; var Text: Text[250]): Boolean
    begin
    end;

    procedure LookUpAppUserGrpCode(NewCompanyName: Text[30]; var Text: Text[250]; Editable: Boolean): Boolean
    begin
    end;

    procedure GetPermissionTxt(PermissionType: Option "Assigning Permission","Approval Permission"; _CompanyName: Text[30]): Text[1024]
    begin
    end;

    procedure GetTypeTxt(): Text[1024]
    begin
    end;
}