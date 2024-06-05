---@diagnostic disable: duplicate-set-field
require("test.setup")()

local rewards = require "rewards"

describe("rewards", function()
  local originalGetMaximumEntry
  local originalThreshold
  local originalRewardFactor

  setup(function()
    originalGetMaximumEntry = rewards.getMaximumEntry
    originalThreshold = rewards.Threshold
    originalRewardFactor = rewards.RewardFactor
  end)

  teardown(function()
    rewards.getMaximumEntry = originalGetMaximumEntry
    rewards.Threshold = originalThreshold
    rewards.RewardFactor = originalRewardFactor
  end)


  it("it should return 0 reward if we are below threshold", function()
    rewards.Threshold = 42
    rewards.RewardFactor = 10
    rewards.getMaximumEntry = function()
      return { value = 41 }
    end

    assert.are.equal(rewards.nextReward(), 0)
  end)

  -- FUZZER
  it("it should return with correct calculation if we are above or at threshold", function()
    for i = 0, 100 do
      rewards.Threshold = math.random(1, 10000)
      local maxEntryVal = math.random(rewards.Threshold, rewards.Threshold * 2)
      rewards.RewardFactor = math.random(1, 100)
      rewards.getMaximumEntry = function()
        return { value = maxEntryVal }
      end

      assert.are.equal(rewards.nextReward(), maxEntryVal * rewards.RewardFactor)
    end
  end)
end)