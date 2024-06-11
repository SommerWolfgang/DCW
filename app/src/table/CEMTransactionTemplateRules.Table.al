table 6086408 "CEM Transaction Template Rules"
{
    Caption = 'Transaction Import Template Rules';

    fields
    {
        field(1; "Template Code"; Code[20])
        {
            Caption = 'Transaction Format';
            TableRelation = "CEM Transaction Template";
        }
        field(2; "Rule No."; Integer)
        {
            Caption = 'Rule No.';
        }
        field(3; Rule; Option)
        {
            Caption = 'Rule';
            OptionCaption = 'Exclude lines containing text';
            OptionMembers = "Skip Lines With Text";
        }
        field(4; Text; Text[30])
        {
            Caption = 'Text';
        }
    }

    keys
    {
        key(Key1; "Template Code", "Rule No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        TemplateRules: Record "CEM Transaction Template Rules";
    begin
        if RuleRequiresTxt() then
            TestField(Text);

        if "Rule No." = 0 then begin
            TemplateRules.SetRange("Template Code", "Template Code");
            if TemplateRules.FindLast() then
                "Rule No." := TemplateRules."Rule No." + 1
            else
                "Rule No." := 1;
        end;
    end;

    trigger OnModify()
    var
        TemplateRules: Record "CEM Transaction Template Rules";
    begin
        if RuleRequiresTxt() then
            TestField(Text);
    end;

    var
        OnlyOneAllowedErr: Label 'Only one rule of this type is allowed';


    procedure RuleRequiresTxt(): Boolean
    begin
        exit(Rule in [Rule::"Skip Lines With Text"]);
    end;
}

