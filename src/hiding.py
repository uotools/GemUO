#!/usr/bin/python

from uo.skills import *
from gemuo.simple import simple_run
from gemuo.engine.training import SkillTraining
from gemuo.engine.messages import PrintMessages
from gemuo.engine.guards import Guards
from gemuo.engine.watch import Watch

skills = (
    SKILL_HIDING,
    SKILL_DETECT_HIDDEN,
    SKILL_ANATOMY,
    SKILL_EVAL_INT,
    SKILL_ITEM_ID,
    SKILL_ARMS_LORE,
)

def run(client):
    PrintMessages(client)
    Guards(client)
    Watch(client)
    return SkillTraining(client, skills, round_robin=False)

simple_run(run)
